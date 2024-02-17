//
//  StStudTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 06/11/2023.
//

import UIKit

class StStudTableViewCell:UITableViewCell {
    


    
    
    @IBOutlet weak var lbldates: UILabel!
    @IBOutlet weak var lblnohMostand: UILabel!
    @IBOutlet weak var lblmostand: UILabel!
    @IBOutlet weak var lbltyp_inv: UILabel!
    @IBOutlet weak var lbltyp_cont: UILabel!
    @IBOutlet weak var lblusers: UILabel!
    @IBOutlet weak var lbld_f: UILabel!
    @IBOutlet weak var lbl_dt: UILabel!
    @IBOutlet weak var lblmadin: UILabel!
    @IBOutlet weak var lbldain: UILabel!


   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,nohmostand : String
                   ,mostand : String
                   ,typ_inv : String
                   ,typ_cont : String
                   ,users : String
                   ,d_f : String
                   ,d_t : String
                   ,madin : Double
                   ,dain : Double
                  ){
        
        print("dat")
        lbldates.text = dates
        lblnohMostand.text = nohmostand
        lblmostand.text = mostand
        lbltyp_inv.text = typ_inv
        lbltyp_cont.text = typ_cont
        lblusers.text = users
        lbld_f.text = d_f
        lbl_dt.text = d_t
        lblmadin.text = "\(madin)"
        lbldain.text = "\(dain)"

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
