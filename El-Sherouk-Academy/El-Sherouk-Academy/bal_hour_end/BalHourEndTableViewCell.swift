//
//  BalHourEndTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 26/10/2023.
//

import UIKit

class BalHourEndTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblSafDrasi: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblGen: UILabel!
    
    @IBOutlet weak var lblMada: UILabel!
    
    @IBOutlet weak var lblNoh: UILabel!

    
    @IBOutlet weak var lblQin: UILabel!
    
    @IBOutlet weak var lblQout: UILabel!
    
    @IBOutlet weak var lblR: UILabel!
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(safDrasi : String
                   ,name : String
                   ,gen : String
                   ,mada : String
                   ,noh : String
                   ,qin : Double
                   ,qout : Double
                   ,r : Double){
        print("dat")
        lblSafDrasi.text = safDrasi
        lblName.text = name
        lblGen.text = gen
        lblMada.text = mada
        lblNoh.text = noh
        lblQin.text = "\(qin)"
        lblQout.text = "\(qout)"
        lblR.text = "\(r)"
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
