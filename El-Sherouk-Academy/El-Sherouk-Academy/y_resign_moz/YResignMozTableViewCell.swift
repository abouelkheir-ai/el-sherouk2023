//
//  YResignMozTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 31/10/2023.
//

import UIKit

class YResignMozTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbldates: UILabel!
    
    @IBOutlet weak var lblmostand: UILabel!
    
    @IBOutlet weak var lblnMoz: UILabel!
    @IBOutlet weak var lblnoCont: UILabel!
    @IBOutlet weak var lblnWaz: UILabel!
    @IBOutlet weak var lblnotes: UILabel!


   
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,mostand : String
                   ,moz : String
                   ,noCont : Int
                   ,nWaz : String
                   ,notes : String
                   ){
        print("dat")
        lbldates.text = dates
        lblmostand.text = mostand
        lblnMoz.text = moz
        lblnoCont.text = "\(noCont)"
        lblnWaz.text = nWaz
        lblnotes.text = notes

       
       
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
