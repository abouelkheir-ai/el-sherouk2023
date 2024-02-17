//
//  YamaTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 02/11/2023.
//

import UIKit

class YamaTableViewCell :UITableViewCell {
    
    
    
    @IBOutlet weak var lbldates: UILabel!
    
    @IBOutlet weak var lblnohMostand: UILabel!

    @IBOutlet weak var lblmostand: UILabel!
    
    
    @IBOutlet weak var lblNhadacc: UILabel!
    
    @IBOutlet weak var lbln_acc: UILabel!

    @IBOutlet weak var lblnotes: UILabel!
    
    @IBOutlet weak var lblMadin: UILabel!

    @IBOutlet weak var lblDain: UILabel!

   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,nohmostand : String
                   ,mostand : String
                   ,nhadacc : String
                   ,n_acc : String
                   ,notes : String
                   ,madin : Double
                   ,dain : Double
                  

                  ){
        
        print("dat")
        lbldates.text = dates
        lblnohMostand.text = nohmostand
        lblmostand.text = mostand
        lblNhadacc.text = nhadacc
        lbln_acc.text = n_acc
        lblnotes.text = notes
        lblMadin.text = "\(madin)"
        lblDain.text = "\(dain)"

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
