//
//  ViewController.swift
//  Lab03
//
//  Created by Akash Shrestha on 2023-11-18.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var imgWeatherConition: UIImageView!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tempSwitch: UISwitch!
    
    var locationManager = CLLocationManager()
    var lat = ""
    var long = ""
    var celsius = ""
    var fahrenheit = ""
    var isCelsius = false
    
    var citiesList = [CityWeatherModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfLocation.delegate = self
        tfLocation.autocapitalizationType = .words
        btnActions()
        
        getCurrentLocation()
    }
    
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        lat = "\(userLocation.coordinate.latitude)"
        long = "\(userLocation.coordinate.longitude)"
        
        getWeatherData(location: "\(lat), \(long)")
    }
    
    func getWeatherImage(code: Int) {
        let config = UIImage.SymbolConfiguration(paletteColors: [.systemBlue, .systemBlue, .systemBlue])
        self.imgWeatherConition.preferredSymbolConfiguration = config
        var imageCode = "sun.max.fill"
        
        for item in weatherIcons {
            if item.code == code {
                imageCode = item.text ?? ""
                break
            }
        }
        
        self.imgWeatherConition.image = UIImage(systemName: imageCode)
        self.imgWeatherConition.addSymbolEffect(.pulse)
    }
    
    func btnActions() {
        let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(locationImgButtonTapped(_:)))
        imgLocation.isUserInteractionEnabled = true
        imgLocation.addGestureRecognizer(locationTapGesture)
        
        let searchTapGesture = UITapGestureRecognizer(target: self, action: #selector(searchImgButtonTapped(_:)))
        imgSearch.isUserInteractionEnabled = true
        imgSearch.addGestureRecognizer(searchTapGesture)
    }
    
    @objc func locationImgButtonTapped(_ sender: UITapGestureRecognizer) {
        getWeatherData(location: "\(lat), \(long)")
    }
    
    @objc func searchImgButtonTapped(_ sender: UITapGestureRecognizer) {
        if tfLocation.text?.isEmpty != true {
            getWeatherData(location: tfLocation.text ?? "")
            tfLocation.text = ""
            tfLocation.resignFirstResponder()
        } else {
            tfLocation.shake()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getWeatherData(location: tfLocation.text ?? "")
        tfLocation.text = ""
        tfLocation.resignFirstResponder()
        return true
    }
    
    func getWeatherData(location: String) {
        self.loadingView.startAnimating()
        guard let mainUrl = getApiURL(cityName: location) else {
            print("Invalid URL Request")
            return }
        
        let task = URLSession.shared.dataTask(with: mainUrl) { data, response, error in
            if let err = error {
                print("Error: \(err)")
            }
            
            do {
                if let getData = data {
                    let decodedData = try JSONDecoder().decode(WeatherResponseModel.self, from: getData)
                    
                    DispatchQueue.main.async {
                        self.lblCityName.text = decodedData.location?.name ?? ""
                        self.getWeatherImage(code: decodedData.current?.condition?.code ?? 0)
                        
                        self.celsius = "\(decodedData.current?.temp_c ?? 0.0)"
                        self.fahrenheit = "\(decodedData.current?.temp_f ?? 0.0)"
                        
                        self.tempSwitch(self.tempSwitch)
                        
                        self.loadingView.isHidden = true
                        self.loadingView.stopAnimating()
                        
                        self.citiesList.append(CityWeatherModel(name: decodedData.location?.name ?? "", imgCode: decodedData.current?.condition?.code ?? 0, temperature: self.isCelsius ? self.celsius + " C" : self.fahrenheit + " F"))
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()
        
    }
    
    func getApiURL(cityName: String) -> URL? {
        guard let url = (baseUrl + apiKey + queryPart + "\(cityName)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        return URL(string: url)
    }
    
    @IBAction func btnCityAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "CityListVC", bundle: nil).instantiateViewController(withIdentifier: "CityListVC") as! CityListVC
        vc.getCityList = citiesList
        let vcWithNav = UINavigationController(rootViewController: vc)
        self.present(vcWithNav, animated: true)
    }
    
    @IBAction func tempSwitch(_ sender: UISwitch) {
        isCelsius = !sender.isOn
        lblTemp.text = sender.isOn ? fahrenheit + " F" : celsius + " C"
    }
}

// MARK: - Textfield Shake
extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        
        let fromPoint = CGPoint(x: self.center.x - 5, y: self.center.y)
        let toPoint = CGPoint(x: self.center.x + 5, y: self.center.y)
        animation.fromValue = NSValue(cgPoint: fromPoint)
        animation.toValue = NSValue(cgPoint: toPoint)
        
        self.layer.add(animation, forKey: "position")
    }
}
