//
//  BalHourFTTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 29/10/2023.
//

import UIKit

class BalHourFTTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblSafDrasi: UILabel!
    
    @IBOutlet weak var lblUsers: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGen: UILabel!
    @IBOutlet weak var lblMada: UILabel!
    @IBOutlet weak var lblR: UILabel!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(safDrasi : String
                   ,users : String
                   ,name : String
                   ,gen : String
                   ,mada : String
                   ,r : Double
                   ){
        print("dat")
        lblSafDrasi.text = safDrasi
        lblUsers.text = users
        lblName.text = name
        lblGen.text = gen
        lblMada.text = mada
        lblR.text = "\(r)"
       
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
