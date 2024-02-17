//
//  ChecKPermissionsViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 09/11/2023.
//

import UIKit

class ChecKPermissionsViewController: UIViewController {
    var client: SQLClient?
    var listPermission: [ScreenPermesiion] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func establishDBConnection() {
        client = SQLClient.sharedInstance()
        guard let client = self.client else {
            print("Client not available")
            return
        }
        client.connect("hardsoft.hopto.org:1433", username: "admain", password: "5376274", database: "db_H@rdsoft_2023") { success in
            if success {
                print("Connection successful")
            } else {
                client.disconnect()
                print("Connection error")
            }
        }
    }
    func searchForPermissions(_searchText: String) {
        establishDBConnection()

        guard let client = self.client else {
            print("Client not available")
            return
        }
        let query2 = "SELECT no_forms, s FROM slahiat WHERE id_perm = '" + _searchText + "'"
        
        client.execute(query2) { results in
            guard let result = results else {
                print("Error retrieving data")
                return
            }
            
            print(query2)
            print("Data retrieval successful")
            for table in result {
                guard let table = table as? NSArray else {
                    print("Error converting to array")
                    continue
                }
                for row in table {
                    guard let row = row as? [AnyHashable: Any] else {
                        print("Error in row conversion")
                        continue
                    }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: row)
                        let instance = try JSONDecoder().decode(ScreenPermesiion.self, from: jsonData)
                        self.listPermission.append(instance)
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        
    }
//    func handleButtonClick(_ buttonID: String) {
//        switch buttonID {
//        case "bal_bank":
//            // your logic here
//        case "bal_hour_end":
//            // your logic here
//        case "bal_hour_f":
//            // your logic here
//        case "y_inv":
//            // your logic here
//        case "bal_hour_ft":
//            // your logic here
//        case "bal_kast":
//            // your logic here
//        case "bal_kast_u":
//            // your logic here
//        case "bal_kaz":
//            // your logic here
//        case "bal_taregt_k":
//            // your logic here
//        case "y_stud_behv":
//            // your logic here
//        case "y_stop_kast":
//            // your logic here
//        case "y_resign_moz":
//            // your logic here
//        case "y_resign_rej_moz":
//            // your logic here
//        case "y_new_cont":
//            // your logic here
//        case "y_inv_u":
//            // your logic here
//        case "y_disc_inv":
//            // your logic here
//        case "y_cont_moz":
//            // your logic here
//        case "y_cont_clr_moz":
//            // your logic here
//        case "y_clr_moz":
//            // your logic here
//        case "y_att_abs_group_tt":
//            // your logic here
//        case "y_att_abs_group_t":
//            // your logic here
//        case "y_att_abs_group":
//            // your logic here
//        case "y_att_abs_f":
//            // your logic here
//        case "y_ama":
//            // your logic here
//        case "y_abs_fardi":
//            // your logic here
//        case "wrk_ord_g":
//            // your logic here
//        case "wrk_ord_f":
//            // your logic here
//        case "t_stud":
//            // your logic here
//        case "t_masr":
//            // your logic here
//        case "t_masr_t":
//            // your logic here
//        case "t_irad_t":
//            // your logic here
//        case "t_irad":
//            // your logic here
//        case "st_stud":
//            // your logic here
//        case "st_kaz":
//            // your logic here
//        case "st_hour_f":
//            // your logic here
//        case "st_f_stud":
//            // your logic here
//        case "st_bank":
//            // your logic here
//        case "st_bank_t":
//            // your logic here
//        case "st_acc":
//            // your logic here
//        case "name_stud_ss":
//            // your logic here
//        case "name_stud_no":
//            // your logic here
//        case "name_stud_g":
//            // your logic here
//        case "name_stud_f":
//            // your logic here
//        case "name_stud_end":
//            // your logic here
//        default:
//            break
//        }
//    }
//
//    // Call the function with the appropriate button identifier
//    handleButtonClick("bal_bank") // Replace with the relevant button identifier


}
