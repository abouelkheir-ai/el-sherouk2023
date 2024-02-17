//
//  BalHoudEndViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 26/10/2023.
//

import UIKit
import SwiftMessages
class BalHoudEndViewController: UIViewController , UITableViewDelegate, UITableViewDataSource   {
    var client = SQLClient.sharedInstance()
    var list_balHourEnd: [BalHourEnd] = []
    var listPermission: [ScreenPermesiion] = []

    var termBegin = ""
    var termEnd = ""
    
    
    var _qIn = 0.0;
    var _qOut = 0.0;
    var _r = 0.0;
    
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
        if let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "bal_hou_end_filter_ui") as? BalHourEndFilterViewController {
            self.navigationController?.pushViewController(vcSecondView, animated: true)
        } else {
            print("Error: Unable to instantiate view controller with identifier 'bal_hou_end_filter_ui'")
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
        print(list_balHourEnd.count)
        return list_balHourEnd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bal_hour_cell") as? BalHourEndTableViewCell else { return UITableViewCell() }
        print(indexPath)
        cell.setupCell(safDrasi: list_balHourEnd[indexPath.row].n_cls ?? "", name: list_balHourEnd[indexPath.row].n_stud ?? "", gen: list_balHourEnd[indexPath.row].gen ?? "", mada: list_balHourEnd[indexPath.row].n_sub ?? "", noh: list_balHourEnd[indexPath.row].typ_cont ?? "", qin: list_balHourEnd[indexPath.row].q_in ?? 0, qout: list_balHourEnd[indexPath.row].q_out ?? 0, r: list_balHourEnd[indexPath.row].r ?? 0)
        
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

            self.list_balHourEnd.removeAll()
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
                            let instance = try JSONDecoder().decode(BalHourEnd.self, from: jsonData)
                            self.list_balHourEnd.append(instance)
                            self._qIn += instance.q_in ?? 0
                            self._qOut += instance.q_out ?? 0
                            self._r += instance.r ?? 0
                          
                           

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
    
 
    func showAlertWithDetails(r: Double, _qIn: Double, _qOut: Double) {
        let  message = """
        ساعات منفذه: \(_qIn)
        ساعات تعاقد: \(_qOut)
        رصيد ساعات: \(r)

        """
        let alert = UIAlertController(title: "الاجمالي", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func show_total(_ sender: Any) {
        print(_r)
        showAlertWithDetails(r: _r, _qIn: _qIn, _qOut: _qOut)
    }
    
   
    
    @IBAction func search(_ sender: Any) {
        print("search")
        
        _r = 0.0;
        _qIn = 0.0;
        _qOut = 0.0;
      
        

        connect(_query: query)
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if(self.list_balHourEnd.isEmpty){
                self.showSnackBar(message: "no data")
            }
        }
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
   
       
   

}


