//
//  YInvViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 28/10/2023.
//

import UIKit
import SwiftMessages
class YInvViewController: UIViewController , UITableViewDelegate, UITableViewDataSource   {
    var client = SQLClient.sharedInstance()
    var list_yInv: [YInv] = []
    var listPermission: [ScreenPermesiion] = []

    var _t_inv = 0.0;
    var _k = 0.0;
    var _cash = 0.0;
    var _tKast = 0.0;

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
   
    
   
    
    @IBAction func goFilter(_ sender: Any) {
        print("goFilter tapped")
        if let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "y_inv_filter_ui") as? YINVFilterViewController {
            vcSecondView.termBegin = termBegin
            vcSecondView.termEnd = termEnd
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
        print(list_yInv.count)
        return list_yInv.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "y_inv_cell") as? YInvTableViewCell else { return UITableViewCell() }
        print(indexPath)
        cell.setupCell(dates: list_yInv[indexPath.row].dates ?? "", mostand: list_yInv[indexPath.row].mostand ?? "", typ_inv: list_yInv[indexPath.row].typ_inv ?? "", d_f: list_yInv[indexPath.row].d_f ?? "", d_t: list_yInv[indexPath.row].d_t ?? "", users: list_yInv[indexPath.row].users ?? "", n_cls: list_yInv[indexPath.row].n_cls ?? "", n_stud: list_yInv[indexPath.row].n_stud ?? "", t_inv: list_yInv[indexPath.row].t_inv ?? 0, k: list_yInv[indexPath.row].k ?? 0, cash: list_yInv[indexPath.row].cash ?? 0, t_kast: list_yInv[indexPath.row].t_kast ?? 0, d_kast: list_yInv[indexPath.row].d_kast ?? "")
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

            self.list_yInv.removeAll()
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
                            let instance = try JSONDecoder().decode(YInv.self, from: jsonData)
                            self.list_yInv.append(instance)
                            self._t_inv += instance.t_inv ?? 0
                            self._tKast += instance.t_kast ?? 0
                            self._k += instance.k ?? 0
                            self._cash += instance.cash ?? 0

                          
                           

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
    
 
    func showAlertWithDetails(tInv: Double, tKast: Double, K: Double, cash: Double) {
        let  message = """
        قيمه المواد: \(tInv)
        الخصم: \(K)
        المسدد: \(cash)
        المتبقي: \(tKast)


        """
        let alert = UIAlertController(title: "الاجمالي", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func show_total(_ sender: Any) {
        showAlertWithDetails(tInv: _t_inv, tKast: _tKast, K: _k, cash: _cash)
    }
    
    func showSnackBar(message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Snack Bar", body: message)
        view.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        SwiftMessages.show(config: config, view: view)
    }
    
    @IBAction func search(_ sender: Any) {
        print("search")
        
         _t_inv = 0.0;
         _k = 0.0;
         _cash = 0.0;
         _tKast = 0.0;
      
        

        connect(_query: query)
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if(self.list_yInv.isEmpty){
                self.showSnackBar(message: "no data")
            }
        }
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
   
       
   

}


