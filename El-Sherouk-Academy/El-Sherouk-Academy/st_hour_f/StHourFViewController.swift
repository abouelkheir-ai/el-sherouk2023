//
//  StHourFViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 07/11/2023.
//

import UIKit
import SwiftMessages
class StHourFViewController: UIViewController , UITableViewDelegate, UITableViewDataSource   {
    var client = SQLClient.sharedInstance()
    var list_stHourF: [StHourF] = []
    var listPermission: [ScreenPermesiion] = []

    var _qin = 0.0;
    var _qout = 0.0;
    var _qacc = 0.0;
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
        if let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "st_hour_f_filter") as? StHourFFilterViewController {
            vcSecondView.termBegin = termBegin
            vcSecondView.termEnd = termEnd
            self.navigationController?.pushViewController(vcSecondView, animated: true)
        } else {
            print("Error: Unable to instantiate view controller with identifier 'st_hour_f_filter'")
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
        print(list_stHourF.count)
        
        return list_stHourF.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "stHourF_cell") as? StHourFTableViewCell else { return UITableViewCell() }
        print(indexPath)
        cell.setupCell(dates: list_stHourF[indexPath.row].dates ?? "", noh_mostand: list_stHourF[indexPath.row].noh_mostand ?? "", mostand: list_stHourF[indexPath.row].mostand ?? "", users: list_stHourF[indexPath.row].users ?? "", n_cls: list_stHourF[indexPath.row].n_cls ?? "", n_stud: list_stHourF[indexPath.row].n_sub ?? "", n_moz: list_stHourF[indexPath.row].n_moz ?? "", notes: list_stHourF[indexPath.row].notes ?? "", q_in: list_stHourF[indexPath.row].q_in ?? 0, q_out: list_stHourF[indexPath.row].q_out ?? 0, q_acc: list_stHourF[indexPath.row].q_acc ?? 0)
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

            self.list_stHourF.removeAll()
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
                            let instance = try JSONDecoder().decode(StHourF.self, from: jsonData)
                            self.list_stHourF.append(instance)
                            self._qin += instance.q_in ?? 0
                            self._qout += instance.q_out ?? 0
                            self._qacc += instance.q_acc ?? 0
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
    
 
    func showAlertWithDetails(qin: Double,qout: Double,qacc: Double,r: Double) {
        let  message = """
        ساعات التعاقد: \(qin)
        ساعات تنفيذ: \(qout)
        ساعات اذونك:\(qacc)
        المتبقي: \(r)

        """
        let alert = UIAlertController(title: "الاجمالي", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func show_total(_ sender: Any) {
        showAlertWithDetails(qin: _qin, qout: _qout, qacc: _qacc, r: _r)
    }
    
   
    
    @IBAction func search(_ sender: Any) {
        print("search")
        
        _qin = 0.0;
        _qout =  0.0;
        _qacc = 0.0;
        _r =  0.0;

      
        

        connect(_query: query)
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if(self.list_stHourF.isEmpty){
                self.showSnackBar(message: "no data")
            }
        }
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
   
       
   

}



