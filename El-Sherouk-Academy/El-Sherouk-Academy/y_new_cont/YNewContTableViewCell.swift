//
//  YNewContTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 31/10/2023.
//

import UIKit

class YNewContTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbldates: UILabel!
    
    @IBOutlet weak var lblmostand: UILabel!
    
    @IBOutlet weak var lblemployee: UILabel!
    
    @IBOutlet weak var lblusers: UILabel!
    
    @IBOutlet weak var lblLevel: UILabel!
    
    @IBOutlet weak var lblNtalb: UILabel!
    
    @IBOutlet weak var lblgen: UILabel!
    @IBOutlet weak var lblInvoice: UILabel!
    @IBOutlet weak var lblAkd: UILabel!
    @IBOutlet weak var lblt_inv: UILabel!
    @IBOutlet weak var lblcash: UILabel!
  

    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,mostand : String
                   ,employee : String
                   ,users : String
                   ,level : String
                   ,nStudent : String
                   ,gen : String
                   ,inv : String,akd : String,t_inv : Double,cash : Double){
        print("dat")
        lbldates.text = dates
        lblmostand.text = mostand
        lblemployee.text = employee
        lblusers.text = users
        lblLevel.text = level
        lblNtalb.text = nStudent
        lblgen.text = gen
        lblInvoice.text = inv
        lblAkd.text = "\(akd)"
        lblt_inv.text = "\(t_inv)"
        lblcash.text = "\(cash)"
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
