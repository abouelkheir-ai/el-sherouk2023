//
//  YstudbehaveTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 31/10/2023.
//

import UIKit

class YstudbehaveTableViewCell:  UITableViewCell {
    
    
    @IBOutlet weak var lbldates: UILabel!
    
    @IBOutlet weak var lblmostand: UILabel!
    @IBOutlet weak var lbln_stud: UILabel!

    @IBOutlet weak var lblnoh: UILabel!
    
    @IBOutlet weak var lblLevel: UILabel!
    
    @IBOutlet weak var lblSlok: UILabel!
    
    @IBOutlet weak var lblAct: UILabel!
    
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,mostand : String
                   ,nameStud : String
                   ,noh : String
                   ,safDrasi : String
                   ,slook : String
                   ,action : String
                   ){
        print("dat")
        lbldates.text = dates
        lblmostand.text = mostand
        lbln_stud.text = nameStud
        lblnoh.text = noh
        lblLevel.text = safDrasi
        lblSlok.text = slook
        lblAct.text = action
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
