//
//  YcontMozTableViewCell.swift
//  El-Sherouk-Academy
//
//  Created by mac on 01/11/2023.
//

import UIKit

class YcontMozTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblnMoz: UILabel!
    
    @IBOutlet weak var lblmostand: UILabel!
    
    @IBOutlet weak var lbldateIn: UILabel!
    
    @IBOutlet weak var lblWazefa: UILabel!
    
    @IBOutlet weak var lblnohDwam: UILabel!
    
    @IBOutlet weak var lbllastSal: UILabel!
    
    @IBOutlet weak var lblSal: UILabel!
    @IBOutlet weak var lblhomeSal: UILabel!
    @IBOutlet weak var lblcallSal: UILabel!
   
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(mozaf : String
                   ,mostand : String
                   ,datein : String
                   ,wazefa : String
                   ,nohDwam : String
                   ,lastSal : Double
                   ,sal : Double
                   ,homeSal : Double,callSal : Double){
        print("dat")
        lblnMoz.text = mozaf
        lblmostand.text = mostand
        lbldateIn.text = datein
        lblWazefa.text = wazefa
        lblnohDwam.text = nohDwam
        lbllastSal.text = "\(lastSal)"
        lblSal.text = "\(sal)"
        lblhomeSal.text = "\(homeSal)"
        lblcallSal.text = "\(callSal)"

        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
