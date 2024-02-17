//
//  BalKstViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 29/10/2023.
//

import UIKit
import SwiftMessages
class BalKstViewController: UIViewController , UITableViewDelegate, UITableViewDataSource   {
    var client = SQLClient.sharedInstance()
    var list_balKast: [BalKast] = []
    var listPermission: [ScreenPermesiion] = []

  
    var _r = 0.0;
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
        if let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "bal_kast_filter_ui") as? BalKastFilterViewController {
            vcSecondView.termBegin = termBegin
            vcSecondView.termEnd = termEnd
            self.navigationController?.pushViewController(vcSecondView, animated: true)
        } else {
            print("Error: Unable to instantiate view controller with identifier 'bal_kast_filter_ui'")
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
        print(list_balKast.count)
        return list_balKast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bal_kast_cell") as? BalKastTableViewCell else { return UITableViewCell() }
        print(indexPath)
//       /* cell.setupCell(safDrasi: list_balHourEndF[indexPath.row].n_cls ?? "", name: list_balHourEndF[indexPath.row].n_stud ?? "", gen: list_balHourEndF[indexPath.row].gen ?? "", mada: list_balHourEndF[indexPath.row].n_sub ?? "", qin: list_balHourEndF[indexPath.row].q_in ?? 0, qout: list_balHourEndF[indexPath.row].q_out ?? 0, r: list_b*/alHourEndF[indexPath.row].r ?? 0)
        cell.setupCell(dateKast: list_balKast[indexPath.row].d_kast ?? "", typeInv: list_balKast[indexPath.row].typ_inv ?? "", mozaf: list_balKast[indexPath.row].n_moz ?? "", users: list_balKast[indexPath.row].users ?? "", nClass: list_balKast[indexPath.row].n_cls ?? "", nameStudent: list_balKast[indexPath.row].n_stud ?? "", r: list_balKast[indexPath.row].r ?? 0, gen: list_balKast[indexPath.row].gen ?? "")
        return cell
    }
    func connect(_query: String, completion: @escaping (Bool) -> Void) {
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

            self.list_balKast.removeAll()
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
                            let instance = try JSONDecoder().decode(BalKast.self, from: jsonData)
                            self.list_balKast.append(instance)
                            
                            self._r += instance.r ?? 0
                          
                           
                            completion(true) // Replace with the actual success condition

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
    
 
    func showAlertWithDetails(r: Double) {
        let  message = """
        الرصيد: \(r)

        """
        let alert = UIAlertController(title: "الاجمالي", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func show_total(_ sender: Any) {
        print(_r)
        showAlertWithDetails(r: _r)
    }
    
   
    
    @IBAction func search(_ sender: Any) {
        print("search")
        
        _r = 0.0;
       
      
        

        connect(_query: query) { success in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.rowHeight = UITableView.automaticDimension
                self.tableView.estimatedRowHeight = 600
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    if self.list_balKast.isEmpty {
                        self.showSnackBar(message: "no data")
                    }
                }
            }
        }
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
   
       
   

}


