//
//  StKazTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 07/11/2023.
//

import UIKit

class StKazTableViewCell:UITableViewCell {
    
    
    
    

    @IBOutlet weak var lbldates: UILabel!
    @IBOutlet weak var lblnohMostand: UILabel!
    @IBOutlet weak var lblmostand: UILabel!
    @IBOutlet weak var lblhh: UILabel!
    @IBOutlet weak var lblnotes: UILabel!
    @IBOutlet weak var lblmadin: UILabel!
    @IBOutlet weak var lbldain: UILabel!
    @IBOutlet weak var lblr: UILabel!


   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,nohmostand : String
                   ,mostand : String
                   ,hh : String
                   ,notes : String
                   ,madin : Double
                   ,dain : Double
                   ,r : Double
                  ){
        
        print("dat")
        lbldates.text = dates
        lblnohMostand.text = nohmostand
        lblmostand.text = mostand
        lblhh.text = hh
        lblnotes.text = notes
        lblmadin.text = "\(madin)"
        lbldain.text = "\(dain)"
        lblr.text = "\(r)"
       

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
