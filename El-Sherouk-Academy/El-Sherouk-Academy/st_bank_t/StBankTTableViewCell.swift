//
//  StBankTTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 08/11/2023.
//

import UIKit

class StBankTTableViewCell:UITableViewCell {
    
    
    
    @IBOutlet weak var lbldates: UILabel!
    @IBOutlet weak var lblmadin: UILabel!
    @IBOutlet weak var lbldain: UILabel!
    @IBOutlet weak var lblr: UILabel!


   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    


    func setupCell(dates : String
                   ,madin : Double
                   ,dain : Double
                   ,r : Double
                  ){
        
        print("dat")
        lbldates.text = dates
        lblmadin.text =  "\(madin)"
        lbldain.text =  "\(dain)"
        lblr.text =  "\(r)"

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
