//
//  TableViewCell.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 14.07.2021.
//

import UIKit

class CountryCodeCell: UITableViewCell {

    @IBOutlet weak var flagImage: UIImageView!{
        didSet{
            imageView?.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var countryName: UILabel!
    
    var country:CountryPresentation!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        countryName.text = country.name
        countryCode.text = country.code
        imageView?.image = country.flagImage
      
    }
    
}
