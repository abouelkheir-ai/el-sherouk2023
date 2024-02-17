//
//  YattabsGroupTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 02/11/2023.
//

import UIKit

class YattabsGroupTableViewCell: UITableViewCell {
   

    
    @IBOutlet weak var lbldates: UILabel!
    
    @IBOutlet weak var lblmostand: UILabel!
    
    @IBOutlet weak var lblnusers: UILabel!
    
    @IBOutlet weak var lblnStudt: UILabel!
    
    @IBOutlet weak var lblgen: UILabel!
    
    @IBOutlet weak var lblnCls: UILabel!
    
    @IBOutlet weak var lblnGroup: UILabel!
    
    @IBOutlet weak var lblnSect: UILabel!
    
    @IBOutlet weak var lblnSub: UILabel!
    
    @IBOutlet weak var lblnMoz: UILabel!
    
    @IBOutlet weak var lblattAbs: UILabel!
    @IBOutlet weak var lblabsResn: UILabel!

    
   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,mostand : String
                   ,users : String
                   ,student : String
                   ,gen : String
                   ,cls : String
                   ,group : String
                   ,sect : String
                   ,sub : String
                   ,moz : String
                   ,attabs : String
                   ,absresn : String

                  ){
        
        print("dat")
        lbldates.text = dates
        lblmostand.text = mostand
        lblnusers.text = users
        lblnStudt.text = student
        lblgen.text = gen
        lblnCls.text = cls
        lblnGroup.text = group
        lblnSect.text = sect
        lblnSub.text = sub
        lblnMoz.text = moz
        lblattAbs.text = attabs
        lblabsResn.text = absresn

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
