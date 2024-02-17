//
//  YrejRenewTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 31/10/2023.
//

import UIKit

class YrejRenewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbldates: UILabel!
    
    @IBOutlet weak var lblmostand: UILabel!
    
    @IBOutlet weak var lblnStudent: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var lbldt: UILabel!
    @IBOutlet weak var lblnotes: UILabel!
    @IBOutlet weak var lblP: UILabel!


   
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,mostand : String
                   ,nStudent : String
                   ,level : String
                   ,dt : String
                   ,notes : String
                   ,p : Double

                   ){
        print("dat")
        lbldates.text = dates
        lblmostand.text = mostand
        lblnStudent.text = nStudent
        lblLevel.text = level
        lbldt.text = dt
        lblnotes.text = notes
        lblP.text = "\(p)"

       
       
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
