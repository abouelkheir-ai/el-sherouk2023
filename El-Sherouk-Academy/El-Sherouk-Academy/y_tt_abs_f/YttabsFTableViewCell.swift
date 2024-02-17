//
//  YttabsFTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 02/11/2023.
//

import UIKit

class YttabsFTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var lbldates: UILabel!
    
    @IBOutlet weak var lblmostand: UILabel!
    
    @IBOutlet weak var lblatt_abs: UILabel!
    
    @IBOutlet weak var lblnusers: UILabel!
    
    @IBOutlet weak var lblnCls: UILabel!

    @IBOutlet weak var lblnStudt: UILabel!
    
    @IBOutlet weak var lblnStub: UILabel!

    @IBOutlet weak var lblnMoz: UILabel!

    @IBOutlet weak var lbltimeF: UILabel!
    
    @IBOutlet weak var lbltimeT: UILabel!
    
    @IBOutlet weak var lblq: UILabel!
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,mostand : String
                   ,att_abs : String
                   ,users : String
                   ,cls : String
                   ,student : String
                   ,sub : String
                   ,moz : String
                   ,q : Int

                  ){
        
        print("dat")
        lbldates.text = dates
        lblmostand.text = mostand
        lblatt_abs.text = att_abs
        lblnusers.text = users
        lblnCls.text = cls
        lblnStudt.text = student
        lblnStub.text = sub
        lblnMoz.text = moz
//        lbltimeF.text = timet
//        lbltimeT.text = timef
        lblq.text = "\(q)"

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
