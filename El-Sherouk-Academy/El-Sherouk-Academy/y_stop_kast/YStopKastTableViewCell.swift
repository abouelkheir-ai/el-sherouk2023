//
//  YStopKastTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 31/10/2023.
//

import UIKit

class YStopKastTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbldates: UILabel!
    
    @IBOutlet weak var lblmostand: UILabel!
    
    @IBOutlet weak var lblnotes: UILabel!
    
    @IBOutlet weak var lblusers: UILabel!
    
    @IBOutlet weak var lblNmoz: UILabel!
    
    @IBOutlet weak var lblNcls: UILabel!
    
    @IBOutlet weak var lblnStud: UILabel!
    @IBOutlet weak var lblgen: UILabel!
    @IBOutlet weak var lblinv: UILabel!
    @IBOutlet weak var lbldKast: UILabel!
    @IBOutlet weak var lblstKast: UILabel!
    @IBOutlet weak var lblcashOut: UILabel!

    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,mostand : String
                   ,notes : String
                   ,users : String
                   ,moz : String
                   ,cls : String
                   ,stud : String
                   ,gen : String
                   ,inv : Double
                   ,dKast : String
                   ,stkast : Double
                   ,cashout: Double ){
        print("dat")
        lbldates.text = dates
        lblmostand.text = mostand
        lblnotes.text = notes
        lblusers.text = users
        lblNmoz.text = moz
        lblNcls.text = cls
        lblnStud.text = stud
        lblgen.text = gen
        lblinv.text = "\(inv)"
        lbldKast.text = dKast
        lblstKast.text = "\(stkast)"
        lblcashOut.text = "\(cashout)"

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
