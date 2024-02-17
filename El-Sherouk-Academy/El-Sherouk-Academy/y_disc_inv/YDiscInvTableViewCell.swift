//
//  YDiscInvTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 01/11/2023.
//

import UIKit

class YDiscInvTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbldates: UILabel!
    
    @IBOutlet weak var lblmostand: UILabel!
    
    @IBOutlet weak var lbltyp_inv: UILabel!
    
    @IBOutlet weak var lbluser: UILabel!
    
    @IBOutlet weak var lblMoz: UILabel!
    
    @IBOutlet weak var lbluser_inv: UILabel!
    
    @IBOutlet weak var lbln_stud: UILabel!
    @IBOutlet weak var lbln_cls: UILabel!
    @IBOutlet weak var lbldisc_no: UILabel!
    @IBOutlet weak var lblnotes: UILabel!
    @IBOutlet weak var lblk: UILabel!
   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,mostand : String
                   ,typ_inv : String
                   ,user_k : String
                   ,n_moz : String
                   ,user_inv : String
                   ,n_stud : String
                   ,n_cls : String,disc_no : String,notes : String ,k : Double){
        print("dat")
        lbldates.text = dates
        lblmostand.text = mostand
        lbltyp_inv.text = typ_inv
        lbluser.text = user_k
        lblMoz.text = n_moz
        lbluser_inv.text = user_inv
        lbln_stud.text = n_stud
        lbln_cls.text = n_cls
        lbldisc_no.text = disc_no
        lblnotes.text = notes
        lblk.text = "\(k)"
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
