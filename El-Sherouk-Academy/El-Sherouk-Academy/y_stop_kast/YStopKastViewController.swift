//
//  YStopKastViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 31/10/2023.
//

import UIKit
import SwiftMessages
class YStopKastViewController: UIViewController , UITableViewDelegate, UITableViewDataSource   {
    var client = SQLClient.sharedInstance()
    var list_y_stopKast: [YStopKast] = []
    var listPermission: [ScreenPermesiion] = []

    var _q = 0;
    var _stKast = 0.0;
    var _cashOut = 0.0;

   

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
        if let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "y_stop_kast_filter_ui") as? YStopKastFilterViewController {
            vcSecondView.termBegin = termBegin
            vcSecondView.termEnd = termEnd
            self.navigationController?.pushViewController(vcSecondView, animated: true)
        } else {
            print("Error: Unable to instantiate view controller with identifier 'y_stop_kast_filter_ui'")
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
        print(list_y_stopKast.count)
        _q = list_y_stopKast.count
        return list_y_stopKast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "y_stop_kast_cell") as? YStopKastTableViewCell else { return UITableViewCell() }
        print(indexPath)

       
        cell.setupCell(dates: list_y_stopKast[indexPath.row].dates ?? "", mostand: list_y_stopKast[indexPath.row].mostand ?? "", notes: list_y_stopKast[indexPath.row].notes ?? "", users: list_y_stopKast[indexPath.row].users ?? "", moz: list_y_stopKast[indexPath.row].n_moz ?? "", cls: list_y_stopKast[indexPath.row].n_cls ?? "", stud: list_y_stopKast[indexPath.row].n_stud ?? "", gen: list_y_stopKast[indexPath.row].gen ?? "", inv: list_y_stopKast[indexPath.row].inv ?? 0, dKast: list_y_stopKast[indexPath.row].d_kast ?? "", stkast: list_y_stopKast[indexPath.row].st_kast ?? 0, cashout: list_y_stopKast[indexPath.row].cash_out ?? 0)
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

            self.list_y_stopKast.removeAll()
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
                            let instance = try JSONDecoder().decode(YStopKast.self, from: jsonData)
                            self.list_y_stopKast.append(instance)
                            self._stKast += instance.st_kast ?? 0
                            self._cashOut += instance.cash_out ?? 0

                          
                           

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
    
 
    func showAlertWithDetails(q: Int,tkast: Double,cashout: Double) {
        let  message = """
        عدد اشعارات التوقف: \(q)
        اجمالي التوقف: \(tkast)
        اجمالي الاسترداد: \(cashout)



        """
        let alert = UIAlertController(title: "الاجمالي", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func show_total(_ sender: Any) {
        showAlertWithDetails(q: _q, tkast: _stKast, cashout: _cashOut)
    }
    
   
    
    @IBAction func search(_ sender: Any) {
        print("search")
        
         _q = 0;
        _stKast = 0.0;
        _cashOut = 0.0;

        
      
        

        connect(_query: query)
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if(self.list_y_stopKast.isEmpty){
                self.showSnackBar(message: "no data")
            }
        }
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
   
       
   

}


