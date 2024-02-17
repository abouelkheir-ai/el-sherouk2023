//
//  YattabsGroupTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 02/11/2023.
//

import UIKit

class YattabsGroupTTTableViewCell: UITableViewCell {
    

    @IBOutlet weak var lbln_stud: UILabel!
    
    @IBOutlet weak var lblatt: UILabel!
    
    @IBOutlet weak var lblnabs: UILabel!
    
    @IBOutlet weak var lblno_att_abs: UILabel!
    
  
    
    
   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(n_stud : String
                   ,att : Int
                   ,abs : Int
                   ,noattabs : Int
                
                  ){
        print("dat")
        lbln_stud.text = n_stud
        lblatt.text = "\(att)"
        lblnabs.text = "\(abs)"
        lblno_att_abs.text = "\(noattabs)"
      
        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
