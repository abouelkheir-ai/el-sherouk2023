//
//  StfStudTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 07/11/2023.
//

import UIKit

class StfStudTableViewCell:UITableViewCell {
    
       
    
    @IBOutlet weak var lbldates: UILabel!
    @IBOutlet weak var lblnohMostand: UILabel!
    @IBOutlet weak var lblmostand: UILabel!
    @IBOutlet weak var lbln_stud: UILabel!
    @IBOutlet weak var lbltyp_inv: UILabel!
    @IBOutlet weak var lbltyp_cont: UILabel!
    @IBOutlet weak var lblusers: UILabel!
    @IBOutlet weak var lbld_f: UILabel!
    @IBOutlet weak var lbl_dt: UILabel!
    @IBOutlet weak var lblmadin: UILabel!
    @IBOutlet weak var lbldain: UILabel!
//    @IBOutlet weak var lblr: UILabel!


   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    


    func setupCell(dates : String
                   ,noh_mostand : String
                   ,mostand : String
                   ,n_stud : String
                   ,typ_inv : String
                   ,typ_cont : String
                   ,users : String
                   ,d_f : String
                   ,d_t : String
                   ,madin : Double
                   ,dain : Double
//                   ,r : Double
                  ){
        
        print("dat")
        lbldates.text = dates
        lblnohMostand.text = noh_mostand
        lblmostand.text = mostand
        lbln_stud.text = n_stud
        lbltyp_inv.text = typ_inv
        lbltyp_cont.text = typ_cont
        lblusers.text = users
        lbld_f.text = d_f
        lbl_dt.text =  d_t
        lblmadin.text =  "\(madin)"
        lbldain.text =  "\(dain)"
//        lblr.text =  "\(r)"

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
