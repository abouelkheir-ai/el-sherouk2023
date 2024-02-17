//
//  TmasrTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 06/11/2023.
//

import UIKit

class TmasrTableViewCell:UITableViewCell {
    
    
    @IBOutlet weak var lbldates: UILabel!
    @IBOutlet weak var lblnoh_mostand: UILabel!

    @IBOutlet weak var lblmostand: UILabel!
    @IBOutlet weak var lblusers: UILabel!
    @IBOutlet weak var lblhh: UILabel!
    @IBOutlet weak var lblnStud: UILabel!

    @IBOutlet weak var lblnotes: UILabel!

    @IBOutlet weak var lblcash: UILabel!
    @IBOutlet weak var lblbank: UILabel!
    @IBOutlet weak var lblt: UILabel!



   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String,
                   nohMostand : String
                   ,mostand : String
                   ,users : String
                   ,hh : String
                   ,nStud : String
                   ,notes : String
                   ,cash : Double
                   ,bank : Double
                   ,t : Double

                  ){
        
        print("dat")
        lbldates.text = dates
        lblnoh_mostand.text = nohMostand
        lblmostand.text = mostand
        lblusers.text = users
        lblhh.text = hh
        lblnStud.text = nStud
        lblnotes.text = notes
        lblcash.text = "\(cash)"
        lblbank.text = "\(bank)"
        lblt.text = "\(t)"


        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
