//
//  StAccTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 08/11/2023.
//

import UIKit

class StAccTableViewCell:UITableViewCell {
    
    
    
    @IBOutlet weak var lbldates: UILabel!
    @IBOutlet weak var lblnohMostand: UILabel!
    @IBOutlet weak var lblMostand: UILabel!
    @IBOutlet weak var lblnotes: UILabel!
    @IBOutlet weak var lblmadin: UILabel!
    @IBOutlet weak var lbldain: UILabel!
    @IBOutlet weak var lblr: UILabel!


   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    


    func setupCell(dates : String,
                   nohMostand : String,
                   mostand : String,
                   notes : String
                   ,madin : Double
                   ,dain : Double
                   ,r : Double
                  ){
        
        print("dat")
        lbldates.text = dates
        lblnohMostand.text = nohMostand
        lblMostand.text = mostand
        lblnotes.text = notes
        lblmadin.text =  "\(madin)"
        lbldain.text =  "\(dain)"
        lblr.text =  "\(r)"

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
