//
//  BalKastTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 29/10/2023.
//

import UIKit

class BalKastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbldKast: UILabel!
    
    @IBOutlet weak var lbltypeInv: UILabel!
    
    @IBOutlet weak var lblnMoz: UILabel!
    
    @IBOutlet weak var lblusers: UILabel!
    
    @IBOutlet weak var lblnCls: UILabel!
    
    @IBOutlet weak var lblnStud: UILabel!
    
    @IBOutlet weak var lblgen: UILabel!
    
    @IBOutlet weak var lblr: UILabel!

    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dateKast : String
                   ,typeInv : String
                   ,mozaf : String
                   ,users : String
                   ,nClass : String
                   ,nameStudent : String
                   ,r : Double,gen : String){
        print("dat")
        lbldKast.text = dateKast
        lbltypeInv.text = typeInv
        lblnMoz.text = mozaf
        lblusers.text = users
        lblnCls.text = nClass
        lblnStud.text = nameStudent
        lblgen.text = gen
        lblr.text = "\(r)"

       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
