//
//  WrkOrdGTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 05/11/2023.
//

import UIKit

class WrkOrdGTableViewCell:UITableViewCell {
    
        
    @IBOutlet weak var lbldates: UILabel!
    @IBOutlet weak var lblmostand: UILabel!
    @IBOutlet weak var lblnotes: UILabel!
    @IBOutlet weak var lblusers: UILabel!
    @IBOutlet weak var lblnStud: UILabel!
    @IBOutlet weak var lblnCls: UILabel!
    @IBOutlet weak var lblsub: UILabel!
    @IBOutlet weak var lbldf: UILabel!
    @IBOutlet weak var lbldt: UILabel!


   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,mostand : String
                   ,notes : String
                   ,users : String
                   ,nstud : String
                   ,ncls : String
                   ,sub : String
                   ,df : String
                   ,dt : String
                  ){
        
        print("dat")
        lbldates.text = dates
        lblmostand.text = mostand
        lblnotes.text = notes
        lblusers.text = users
        lblnStud.text = nstud
        lblnCls.text = ncls
        lblsub.text = sub
        lbldf.text = df
        lbldt.text = dt
//        lblQn.text = "\(Qn)"

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
