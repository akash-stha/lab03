//
//  CityListVC.swift
//  Lab03
//
//  Created by Akash Shrestha on 2023-12-09.
//

import UIKit

class CityListVC: UIViewController {

    @IBOutlet weak var cityListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableConfig()
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
    }

}

extension CityListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cityListTableView.dequeueReusableCell(withIdentifier: CityListTableViewCell.identifier, for: indexPath) as! CityListTableViewCell
        cell.lblCityName.text = ""
        cell.lblTemp.text = ""
        return cell
    }
    
}
