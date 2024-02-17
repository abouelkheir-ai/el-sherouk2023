//
//  YusersTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 30/10/2023.
//

import UIKit

class YusersTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbldate_e: UILabel!
    
    @IBOutlet weak var lbltime_e: UILabel!
    
    @IBOutlet weak var lbltyp_e: UILabel!
    
    @IBOutlet weak var lbldates: UILabel!
    
    @IBOutlet weak var lblnoh_mostand: UILabel!
    
    @IBOutlet weak var lblmostand: UILabel!
    
    @IBOutlet weak var lbln_trm: UILabel!
    
    @IBOutlet weak var lbln_user: UILabel!
    
    @IBOutlet weak var lbln_pc: UILabel!

    
    

    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(date_e : String
                   ,time_e : String
                   ,type_e : String
                   ,dates : String
                   ,nohMostand : String
                   ,Mostand : String
                   ,n_trm : String
                   ,n_user : String
                   ,n_pc : String
                  ){
        print("dat")
        lbldate_e.text = date_e
        lbltime_e.text = time_e
        lbltyp_e.text =  type_e
        lbldates.text =  dates
        lblnoh_mostand.text = nohMostand
        lblmostand.text = Mostand
        lbln_trm.text = n_trm
        lbln_user.text = n_user
        lbln_pc.text = n_pc

        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
