//
//  TiradtTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 06/11/2023.
//

import UIKit

class TiradtTableViewCell:UITableViewCell {
    
    
    @IBOutlet weak var lbldates: UILabel!

    @IBOutlet weak var lblcash: UILabel!
    @IBOutlet weak var lblbank: UILabel!
    @IBOutlet weak var lblt: UILabel!



   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,cash : Double
                   ,bank : Double
                   ,t : Double

                  ){
        
        print("dat")
        lbldates.text = dates
        lblcash.text = "\(cash)"
        lblbank.text = "\(bank)"
        lblt.text = "\(t)"


        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
