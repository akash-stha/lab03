//
//  CityListVC.swift
//  Lab03
//
//  Created by Akash Shrestha on 2023-12-09.
//

import UIKit

class CityListVC: UIViewController {

    @IBOutlet weak var cityListTableView: UITableView!
    
    var getCityList = [CityWeatherModel]()
    var isCelciusValue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableConfig()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func tableConfig() {
        cityListTableView.delegate = self
        cityListTableView.dataSource = self
        cityListTableView.register(CityListTableViewCell.nib(), forCellReuseIdentifier: CityListTableViewCell.identifier)
        cityListTableView.reloadData()
    }
    
    func getWeatherImage(code: Int) -> UIImage {
        var imageCode = "sun.max.fill"
        
        for item in weatherIcons {
            if item.code == code {
                imageCode = item.text ?? ""
                break
            }
        }
        
        return UIImage(systemName: imageCode) ?? UIImage()
    }

}

extension CityListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cityListTableView.dequeueReusableCell(withIdentifier: CityListTableViewCell.identifier, for: indexPath) as! CityListTableViewCell
        let model = getCityList[indexPath.item]
        cell.imgIconView.image = getWeatherImage(code: model.imgCode)
        cell.lblCityName.text = model.name
        cell.lblTemp.text = "Temperature: \(isCelciusValue ? model.temp_c : model.temp_f)"
        return cell
    }
    
}
