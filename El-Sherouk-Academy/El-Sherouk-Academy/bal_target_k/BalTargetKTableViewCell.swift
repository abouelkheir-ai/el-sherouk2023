//
//  BalTargetKTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 30/10/2023.
//

import UIKit

class BalTargetKTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblusers: UILabel!
    
    @IBOutlet weak var lblnMoza: UILabel!
    
    @IBOutlet weak var lblK: UILabel!
    
    @IBOutlet weak var lblT: UILabel!
    
    @IBOutlet weak var lblR: UILabel!
    
    

    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(users : String
                   ,nMoz : String
                   ,k : Double
                   ,t : Double
                   ,r : Double
                  ){
        print("dat")
        lblusers.text = users
        lblnMoza.text = nMoz
        lblK.text =  "\(k)"
        lblT.text =  "\(t)"
        lblR.text = "\(r)"
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
