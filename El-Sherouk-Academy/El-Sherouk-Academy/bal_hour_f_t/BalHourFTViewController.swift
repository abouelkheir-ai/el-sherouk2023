//
//  BalHourFTViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 29/10/2023.
//

import UIKit
import SwiftMessages
class BalHourFTViewController: UIViewController , UITableViewDelegate, UITableViewDataSource   {
    var client = SQLClient.sharedInstance()
    var list_balHourEndFT: [BalHourFT] = []
    var listPermission: [ScreenPermesiion] = []

    var termBegin = ""
    var termEnd = ""
    
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
        if let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "balhourft_filter_ui") as? BalHourFTFilterViewController {
            self.navigationController?.pushViewController(vcSecondView, animated: true)
        } else {
            print("Error: Unable to instantiate view controller with identifier 'balhourft_filter_ui'")
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
        print(list_balHourEndFT.count)
        return list_balHourEndFT.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bal_hour_f_t_cell") as? BalHourFTTableViewCell else { return UITableViewCell() }
        print(indexPath)

        cell.setupCell(safDrasi: list_balHourEndFT[indexPath.row].n_cls ?? "", users: list_balHourEndFT[indexPath.row].users ?? "", name: list_balHourEndFT[indexPath.row].n_stud ?? "", gen: list_balHourEndFT[indexPath.row].gen ?? "", mada: list_balHourEndFT[indexPath.row].n_sub ?? "", r: list_balHourEndFT[indexPath.row].r ?? 0)
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

            self.list_balHourEndFT.removeAll()
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
                            let instance = try JSONDecoder().decode(BalHourFT.self, from: jsonData)
                            self.list_balHourEndFT.append(instance)
                            
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
    
 
    func showAlertWithDetails(r: Double) {
        let  message = """
        رصيد ساعات: \(r)

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
        
      
        

        connect(_query: query)
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if(self.list_balHourEndFT.isEmpty){
                self.showSnackBar(message: "no data")
            }
        }
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
   
       
   

}


