
import UIKit

class BalanceBankTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCod: UILabel!
    
    @IBOutlet weak var lblN_bank: UILabel!
    
    @IBOutlet weak var lblAcc_no: UILabel!
    
    @IBOutlet weak var lbl_r: UILabel!
    
    @IBOutlet weak var lbl_rm: UILabel!
    
    @IBOutlet weak var lbl_rd: UILabel!
    
    @IBOutlet weak var lbl_rt: UILabel!
    
    @IBOutlet weak var lbl_rr: UILabel!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(Cod_bank : String
                   ,N_bank : String
                   ,Acc_no : String
                   ,R : Double
                   ,Rm : Double
                   ,Rd : Double
                   ,Rt : Double
                   ,Rr : Double){
        print("dat")
        lblCod.text = Cod_bank
        lblN_bank.text = N_bank
        lblAcc_no.text = Acc_no
        lbl_r.text = "\(R)"
        lbl_rm.text = "\(Rm)"
        lbl_rd.text = "\(Rd)"
        lbl_rt.text = "\(Rt)"
        lbl_rr.text = "\(Rr)"
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
