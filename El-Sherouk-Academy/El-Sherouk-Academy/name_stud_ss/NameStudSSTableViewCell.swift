//
//  NameStudSSTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 08/11/2023.
//

import UIKit

class NameStudSSTableViewCell:UITableViewCell {
    
    
    
    @IBOutlet weak var lbln_cls: UILabel!
    @IBOutlet weak var lbln_stud: UILabel!
    @IBOutlet weak var lbln_moz: UILabel!
    @IBOutlet weak var lbldates: UILabel!
    @IBOutlet weak var lbln_school: UILabel!
    

   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    


    func setupCell(n_cls : String,
                   n_stud : String,
                   n_moz : String,
                   dates : String
                   ,n_school : String
                  
                  ){
        
        print("dat")
        lbln_cls.text = n_cls
        lbln_stud.text = n_stud
        lbln_moz.text = n_moz
        lbldates.text = dates
        lbln_school.text =  n_school
      
        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
