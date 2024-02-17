//
//  BalKastUTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 29/10/2023.
//

import UIKit

class BalKastUTableViewCell: UITableViewCell {
    
    
    
    
    @IBOutlet weak var lblusers: UILabel!
    
    @IBOutlet weak var lblnn: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(
        users : String
        ,r : Double
        
    ){
        lblusers.text = users
        lblnn.text = "\(r)"
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
