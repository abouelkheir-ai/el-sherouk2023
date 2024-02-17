//
//  NameStudEndTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 08/11/2023.
//

import UIKit

class NameStudEndTableViewCell:UITableViewCell {
    
    
    
    @IBOutlet weak var lblnCls: UILabel!
    @IBOutlet weak var lblnStud: UILabel!
    @IBOutlet weak var lblgen: UILabel!
    @IBOutlet weak var lblMoz: UILabel!
    @IBOutlet weak var lblusers: UILabel!
    @IBOutlet weak var lblInvoice: UILabel!
    @IBOutlet weak var lbldf: UILabel!
    @IBOutlet weak var lbldt: UILabel!


   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    


    func setupCell(nCls : String,
                   nStud : String,
                   gen : String,
                   moz : String,
                   users : String,
                   invoice : String
                   ,df : String
                   ,dt : String
                  ){
        
        print("dat")
        lblnCls.text = nCls
        lblnStud.text = nStud
        lblgen.text = gen
        lblMoz.text = moz
        lblusers.text =  users
        lblInvoice.text =  invoice
        lbldf.text =  df
        lbldt.text =  dt

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
