//
//  YInvTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 29/10/2023.
//

import UIKit

class YInvTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lbldates: UILabel!
    
    @IBOutlet weak var lblmostand: UILabel!
    
    @IBOutlet weak var lbltyp_inv: UILabel!
    
    @IBOutlet weak var lbld_f: UILabel!
    
    @IBOutlet weak var lbld_t: UILabel!
    
    @IBOutlet weak var lblusers: UILabel!
    
    @IBOutlet weak var lbln_cls: UILabel!
    @IBOutlet weak var lbln_stud: UILabel!
    @IBOutlet weak var lblt_inv: UILabel!
    @IBOutlet weak var lblk: UILabel!
    @IBOutlet weak var lblcash: UILabel!
    @IBOutlet weak var lblt_kast: UILabel!
    @IBOutlet weak var lbld_kast: UILabel!

    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,mostand : String
                   ,typ_inv : String
                   ,d_f : String
                   ,d_t : String
                   ,users : String
                   ,n_cls : String
                   ,n_stud : String,t_inv : Double,k : Double,cash : Double,t_kast : Double,d_kast : String){
        print("dat")
        lbldates.text = dates
        lblmostand.text = mostand
        lbltyp_inv.text = typ_inv
        lbld_f.text = d_f
        lbld_t.text = d_t
        lblusers.text = users
        lbln_cls.text = n_cls
        lbln_stud.text = n_stud
        lblt_inv.text = "\(t_inv)"
        lblk.text = "\(k)"
        lblcash.text = "\(cash)"
        lblt_kast.text = "\(t_kast)"
        lbld_kast.text = d_kast

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
