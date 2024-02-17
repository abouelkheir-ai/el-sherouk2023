//
//  YClrMozTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 02/11/2023.
//

import UIKit

class YClrMozTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbldates: UILabel!
    
    @IBOutlet weak var lblmostand: UILabel!
    
    @IBOutlet weak var lblnMoz: UILabel!
    
    @IBOutlet weak var lblnCont: UILabel!
    
    @IBOutlet weak var lblnWaz: UILabel!
    
    @IBOutlet weak var lblnotes: UILabel!
    
    
   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,mostand : String
                   ,nMoz : String
                   ,nCont : Int
                   ,nWaz : String
                   ,notes : String
                  ){
        print("dat")
        lbldates.text = dates
        lblmostand.text = mostand
        lblnMoz.text = nMoz
        lblnCont.text = "\(nCont)"
        lblnWaz.text = nWaz
        lblnotes.text = notes
        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
