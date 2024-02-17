//
//  yattabsGroupTTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 02/11/2023.
//

import UIKit

class yattabsGroupTTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbln_stud: UILabel!
    
    @IBOutlet weak var lblsec1: UILabel!

    @IBOutlet weak var lblsec2: UILabel!
    
    @IBOutlet weak var lblsec3: UILabel!
    
    @IBOutlet weak var lblsec4: UILabel!
    
    @IBOutlet weak var lblsec5: UILabel!

  
    
    
   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(n_stud : String
                   ,sec1 : String
                   ,sec2 : String
                   ,sec3 : String
                   ,sec4 : String
                   ,sec5 : String

                  ){
        print("dat")
        lbln_stud.text = n_stud
        lblsec1.text = sec1
        lblsec2.text = sec2
        lblsec3.text = sec3
        lblsec4.text = sec4
        lblsec5.text = sec5

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
