//
//  TstudTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 05/11/2023.
//

import UIKit

class TstudTableViewCell:UITableViewCell {
    
    
    @IBOutlet weak var lblgen: UILabel!
    @IBOutlet weak var lblnCls: UILabel!

    @IBOutlet weak var lblt1: UILabel!
    @IBOutlet weak var lblt2: UILabel!
    @IBOutlet weak var lblt3: UILabel!
    @IBOutlet weak var lblt4: UILabel!

    @IBOutlet weak var lblt: UILabel!



   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(gen : String,
                   cls : String
                   ,t1 : Int
                   ,t2 : Int
                   ,t3 : Int
                   ,t4 : Int
                   ,t : Int
                 
                  ){
        
        print("dat")
        lblgen.text = gen
        lblnCls.text = cls
        lblt1.text = "\(t1)"
        lblt2.text = "\(t2)"
        lblt3.text = "\(t3)"
        lblt4.text = "\(t4)"
        lblt.text = "\(t)"
       
//        lblQn.text = "\(Qn)"

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
