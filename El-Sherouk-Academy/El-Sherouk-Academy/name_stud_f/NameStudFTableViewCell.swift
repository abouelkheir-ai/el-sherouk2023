//
//  NameStudFTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 08/11/2023.
//

import UIKit

class NameStudFTableViewCell:UITableViewCell {
    
    
    
    @IBOutlet weak var lblnCls: UILabel!
    @IBOutlet weak var lblnStud: UILabel!
    @IBOutlet weak var lblgen: UILabel!
    @IBOutlet weak var lblnSchool: UILabel!
    @IBOutlet weak var lblnGov: UILabel!
    @IBOutlet weak var lblusrs: UILabel!
    @IBOutlet weak var lbldf: UILabel!
    @IBOutlet weak var lbldt: UILabel!


   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    


    func setupCell(nCls : String,
                   nStud : String,
                   gen : String,
                   nShcool : String,
                   nGov : String,
                   users : String
                   ,df : String
                   ,dt : String
                  ){
        
        print("dat")
        lblnCls.text = nCls
        lblnStud.text = nStud
        lblgen.text = gen
        lblnSchool.text = nShcool
        lblnGov.text =  nGov
        lblusrs.text =  users
        lbldf.text =  df
        lbldt.text =  dt

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
