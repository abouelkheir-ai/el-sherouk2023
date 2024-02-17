//
//  YusersViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 30/10/2023.
//

import UIKit
import SwiftMessages
class YusersViewController: UIViewController , UITableViewDelegate, UITableViewDataSource   {
    var client = SQLClient.sharedInstance()
    var list_yUsers: [Yusers] = []
    
    var listPermission: [ScreenPermesiion] = []

    var termBegin = ""
    var termEnd = ""
    var currentIndex = 0
    var query = ""
    var onPopWithData: ((String) -> Void)?

    
    
    
    @IBOutlet weak var tableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "تسجيل خروج", style: .plain, target: self, action: #selector(logOut))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate=self
        tableView.dataSource=self
       
        

    }
   
    func showSnackBar(message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Snack Bar", body: message)
        view.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        SwiftMessages.show(config: config, view: view)
    }
   
    
    @IBAction func goFilter(_ sender: Any) {
        print("goFilter tapped")
        if let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "y_users_filter_ui") as? YUsersFilterViewController {
            vcSecondView.termBegin = termBegin
            vcSecondView.termEnd = termEnd
            self.navigationController?.pushViewController(vcSecondView, animated: true)
        } else {
            print("Error: Unable to instantiate view controller with identifier 'bal_kastU_filter_ui'")
        }

    }
    
    
    
    
    
   
    @objc func logOut() {
        UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
        self.navigationController?.popToRootViewController(animated: true)
    }
   
 
    override func viewWillDisappear(_ animated: Bool) {
        client?.disconnect()
        print("disconnect")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(list_yUsers.count)
        return list_yUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "yusers_cell") as? YusersTableViewCell else { return UITableViewCell() }
        print(indexPath)
        cell.setupCell(date_e: list_yUsers[indexPath.row].date_e ?? "", time_e: list_yUsers[indexPath.row].time_e ?? "", type_e: list_yUsers[indexPath.row].type_e ?? "", dates: list_yUsers[indexPath.row].dates ?? "", nohMostand: list_yUsers[indexPath.row].noh_mostand ?? "", Mostand: list_yUsers[indexPath.row].mostand ?? "", n_trm: list_yUsers[indexPath.row].n_trm ?? "", n_user: list_yUsers[indexPath.row].n_user ?? "", n_pc: list_yUsers[indexPath.row].n_pc ?? "")
        return cell
    }
    func connect(_query : String)  {
        print(query)
        print("connect")
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

            self.list_yUsers.removeAll()
            client.execute(self.query) { results in
                guard let result = results else {
                    print("error")
                    return
                }

                print(self.query)
                print("true2")
                for table in result {
                    guard let table = table as? NSArray else {
                        print("here2")
                        continue
                    }
                    //                    print(table)
                    if table.count == 0 {
                        client.disconnect()
                    }
                    for row in table {
                        guard let row = row as? [AnyHashable : Any] else {
                            print("here3")
                            continue
                        }
                        
                        print(row)
                        //                    print(row)
                        // serialize json to text
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: row)
                            let instance = try JSONDecoder().decode(Yusers.self, from: jsonData)
                            self.list_yUsers.append(instance)
                            
                          
                           

                                                    print("done")
                                                    print(instance)
                            self.tableView.reloadData()
                            client.disconnect()

                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    
 
    
    
   
    
    @IBAction func search(_ sender: Any) {
        print("search")
        
       

        connect(_query: query)
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if(self.list_yUsers.isEmpty){
                self.showSnackBar(message: "no data")
            }
        }
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
   
       
   

}


