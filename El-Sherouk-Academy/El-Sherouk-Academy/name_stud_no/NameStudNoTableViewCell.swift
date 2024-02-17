//
//  NameStudNoTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 08/11/2023.
//

import UIKit

class NameStudNoTableViewCell:UITableViewCell {
    
    
    
    @IBOutlet weak var lbldates: UILabel!
    @IBOutlet weak var lblnMoz: UILabel!
    @IBOutlet weak var lblusers: UILabel!
    @IBOutlet weak var lbln_stud: UILabel!
    @IBOutlet weak var lblgen: UILabel!
    @IBOutlet weak var lbllevel: UILabel!
    @IBOutlet weak var lbldateF: UILabel!
    @IBOutlet weak var lblCallL: UILabel!


   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    


    func setupCell(dates : String,
                   nMoz : String,
                   users : String,
                   n_stud : String,
                   gen : String
                   ,level : String
                   ,datf : String
                   ,call : String

                  ){
        
        print("dat")
        lbldates.text = dates
        lblnMoz.text = nMoz
        lblusers.text = users
        lbln_stud.text = n_stud
        lblgen.text =  gen
        lbllevel.text =  level
        lbldateF.text =  datf
        lblCallL.text =  call

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
