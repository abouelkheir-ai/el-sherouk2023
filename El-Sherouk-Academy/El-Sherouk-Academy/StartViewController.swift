//
//  StartViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 26/10/2023.
//

import UIKit

class StartViewController: UIViewController {
    var client: SQLClient?
    var listPermission: [ScreenPermesiion] = []
    var dateTerm: [DateTerm] = []
    var listIdPerm: [NameUsers] = []
    var id_perm = "0"
    var term = "تيرم أول 2024"
    var d1Term = ""
    var d2Term = ""
    let dateFormatter = DateFormatter()
    var user = "1"
    var isFound = false

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "uk")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)


    }
    var end_date = ""
    
//    func getDate() {
//
//        guard let client = self.client else {
//            print("Client not available")
//            return
//        }
//        let query2 = "SELECT d1,d2 from name_trm where n_trm = '" + term + "'"
//        client.execute(query2) { results in
//            guard let result = results else {
//                print("Error retrieving data")
//                return
//            }
//
//            print(query2)
//            print("Data retrieval successful")
//            for table in result {
//                guard let table = table as? NSArray else {
//                    print("Error converting to array")
//                    continue
//                }
//                for row in table {
//                    guard let row = row as? [AnyHashable: Any] else {
//                        print("Error in row conversion")
//                        continue
//                    }
//                    do {
//                        let jsonData = try JSONSerialization.data(withJSONObject: row)
//                        let instance = try JSONDecoder().decode(DateTerm.self, from: jsonData)
//                        self.dateTerm.append(instance)
//                        print(self.dateTerm)
//                        self.d1Term = instance.d1 ?? ""
//                        self.d2Term = instance.d2 ?? ""
//
//                    } catch {
//                        print("Error: \(error)")
//                    }
//                }
//            }
//        }
//
//    }
//    func establishDBConnection() {
//        client = SQLClient.sharedInstance()
//        guard let client = self.client else {
//            print("Client not available")
//            return
//        }
//        client.connect("hardsoft.hopto.org:1433", username: "admain", password: "5376274", database: "db_H@rdsoft_2023") { success in
//            if success {
//                print("Connection successful")
//            } else {
//                client.disconnect()
//                print("Connection error")
//            }
//        }
//    }
    
    @IBAction func start(_ sender: Any) {
        listPermission.removeAll()
        getUserId(_searchText: user) { [weak self] in
            guard let self = self else { return }

            print("Final listPermission:")
            print(self.listPermission)
            searchForPermissions(_searchText: String(id_perm)) { [weak self] in
                guard let self = self else { return }

                print("Final listPermission:")
                print(self.listPermission)

                if self.listPermission.count > 0 {
                    for permission in listPermission {
                        if let noForms = permission.no_forms, let sValue = permission.s, noForms == 301, sValue == 1 {
                            isFound = true
                            print("listPermission.count")
                            print(self.listPermission.count)
                            let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "modernLogin_ui") as! ModernLoginViewController
//                            vcSecondView.termBegin = "2023-09-01"
//                            vcSecondView.termEnd = "2024-01-31"
//                            vcSecondView.listPermission = listPermission
                            print("listPermission")
                            print(self.listPermission)
                            self.navigationController?.pushViewController(vcSecondView, animated: true)
                            
                            break
                        }else{
                            isFound = false
                            print("no permission")
                        }
                    }
                }
                
                
                
            }
            
        }
        
        
    }

     func goTo(_ sender: Any) {
        if self.listPermission.count > 0 {
            for permission in listPermission {
                if let noForms = permission.no_forms, let sValue = permission.s, noForms == 301, sValue == 1 {
                    isFound = true
                    print("listPermission.count")
                    print(self.listPermission.count)
                    let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "name_stud_end") as! NameStudEndViewController
                    vcSecondView.termBegin = "2023-09-01"
                    vcSecondView.termEnd = "2024-01-31"

                    print("listPermission")
                    print(self.listPermission)
                    self.navigationController?.pushViewController(vcSecondView, animated: true)
                    
                    break
                }else{
                    isFound = false
                    print("no permission")
                }
            }
        }
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
    
    func getUserId(_searchText: String, completion: @escaping () -> Void) {
        establishDBConnection()
        guard let client = self.client else {
            print("Client not available")
            return
        }
        let query2 = "SELECT id_perm FROM name_user WHERE users = '" + _searchText + "'"
        
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
//                    print(row)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: row)
                        let instance = try JSONDecoder().decode(NameUsers.self, from: jsonData)
                        self.listIdPerm.append(instance)
                        self.id_perm = instance.id_perm ?? ""
//                        print(self.listPermission.count)
                       
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            completion() // Call the completion handler when the data retrieval is complete
        }
    }

    
    func searchForPermissions(_searchText: String, completion: @escaping () -> Void) {
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
//                    print(row)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: row)
                        let instance = try JSONDecoder().decode(ScreenPermesiion.self, from: jsonData)
                        self.listPermission.append(instance)
//                        print(self.listPermission.count)
                       
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            completion() // Call the completion handler when the data retrieval is complete
        }
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
