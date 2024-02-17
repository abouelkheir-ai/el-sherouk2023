//
//  StHourFTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 07/11/2023.
//

import UIKit

class StHourFTableViewCell:UITableViewCell {
   

    @IBOutlet weak var lbldates: UILabel!
    @IBOutlet weak var lblnohMostand: UILabel!
    @IBOutlet weak var lblmostand: UILabel!
    @IBOutlet weak var lblusers: UILabel!
    @IBOutlet weak var lbln_cls: UILabel!
    @IBOutlet weak var lbln_stud: UILabel!
    @IBOutlet weak var lbln_moz: UILabel!
    @IBOutlet weak var lblnotes: UILabel!
    @IBOutlet weak var lblq_in: UILabel!
    @IBOutlet weak var lblq_out: UILabel!
    @IBOutlet weak var lblq_acc: UILabel!
//    @IBOutlet weak var lblr: UILabel!


   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    func setupCell(dates : String
                   ,noh_mostand : String
                   ,mostand : String
                   ,users : String
                   ,n_cls : String
                   ,n_stud : String
                   ,n_moz : String
                   ,notes : String
                   ,q_in : Double
                   ,q_out : Double
                   ,q_acc : Double
//                   ,r : Double
                  ){
        
        print("dat")
        lbldates.text = dates
        lblnohMostand.text = noh_mostand
        lblmostand.text = mostand
        lblusers.text = users
        lbln_cls.text = n_cls
        lbln_stud.text = n_stud
        lbln_moz.text = n_moz
        lblnotes.text = notes
        lblq_in.text =  "\(q_in)"
        lblq_out.text =  "\(q_out)"
        lblq_acc.text =  "\(q_acc)"
//        lblr.text =  "\(r)"

        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
