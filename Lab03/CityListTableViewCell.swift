//
//  CityListTableViewCell.swift
//  Lab03
//
//  Created by Akash Shrestha on 2023-12-09.
//

import UIKit

class CityListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgIconView: UIImageView!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    
    static let identifier = "CityListTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
