//
//  YinvUTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 01/11/2023.
//

import UIKit

class YinvUTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var lblusers: UILabel!
    @IBOutlet weak var lbltInv: UILabel!
    @IBOutlet weak var lblk: UILabel!
    @IBOutlet weak var lblcash: UILabel!
    @IBOutlet weak var lblt_kast: UILabel!

    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(
                    users : String
                    ,k : Double,tInv : Double,cash : Double,t_kast : Double){
        print("dat")
      
        lblusers.text = users
        lbltInv.text = "\(tInv)"
        lblk.text = "\(k)"
        lblcash.text = "\(cash)"
        lblt_kast.text = "\(t_kast)"

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
