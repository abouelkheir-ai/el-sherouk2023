//
//  BalKazTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 30/10/2023.
//

import UIKit

class BalKazTableViewCell: UITableViewCell {

    @IBOutlet weak var lblcodAcc: UILabel!
    
    @IBOutlet weak var lblnAcc: UILabel!
    
    @IBOutlet weak var lblR: UILabel!
   
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(codAcc : String
                   ,nAcc : String
                   ,r : Double
                   ){
        print("dat")
        lblcodAcc.text = codAcc
        lblnAcc.text = nAcc
        lblR.text = "\(r)"
       
       
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
