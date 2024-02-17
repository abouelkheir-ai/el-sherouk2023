//
//  YcontDrMozTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 01/11/2023.
//

import UIKit

class YcontDrMozTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbldates: UILabel!
    
    @IBOutlet weak var lblmostand: UILabel!
    
    @IBOutlet weak var lblwazefa: UILabel!
    
    @IBOutlet weak var lblnohDwam: UILabel!
    
    @IBOutlet weak var lblsal: UILabel!
    
    @IBOutlet weak var lblhomeSal: UILabel!
    
    @IBOutlet weak var lblcallSal: UILabel!
    @IBOutlet weak var lbldClr: UILabel!
    @IBOutlet weak var lblcClr: UILabel!
   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(dates : String
                   ,mostand : String
                   ,wazefa : String
                   ,nohdwam : String
                   ,sal : Double
                   ,homeSal : Double
                   ,calSal : Double
                   ,dClr : String
                   ,nClr: Double){
        print("dat")
        lbldates.text = dates
        lblmostand.text = mostand
        lblwazefa.text = wazefa
        lblnohDwam.text = nohdwam
        lblsal.text = "\(sal)"
        lblhomeSal.text = "\(homeSal)"
        lblcallSal.text = "\(calSal)"
        lbldClr.text = dClr
        lblcClr.text = "\(nClr)"
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
