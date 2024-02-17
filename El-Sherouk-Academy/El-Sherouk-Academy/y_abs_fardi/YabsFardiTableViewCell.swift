//
//  YabsFardiTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 04/11/2023.
//

import UIKit

class YabsFardiTableViewCell:UITableViewCell {
    
    
    
    
    
    
    
    @IBOutlet weak var lbldates: UILabel!
    @IBOutlet weak var lblmostand: UILabel!
    @IBOutlet weak var lblusers: UILabel!
    @IBOutlet weak var lblnCls: UILabel!
    @IBOutlet weak var lblnStudent: UILabel!
    @IBOutlet weak var lblMada: UILabel!
    @IBOutlet weak var lblqA: UILabel!
    @IBOutlet weak var lblQn: UILabel!


   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,mostand : String
                   ,users : String
                   ,nCls : String
                   ,nStud : String
                   ,mada : String
                   ,qA : Double
                   ,Qn : Double
                  ){
        
        print("dat")
        lbldates.text = dates
        lblmostand.text = mostand
        lblusers.text = users
        lblnCls.text = nCls
        lblnStudent.text = nStud
        lblMada.text = mada
        lblqA.text = "\(qA)"
        lblQn.text = "\(Qn)"

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
