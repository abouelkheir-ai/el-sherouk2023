//
//  T_masr_TViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 06/11/2023.
//

import UIKit
import SwiftMessages
class T_masr_TViewController: UIViewController , UITableViewDelegate, UITableViewDataSource   {
    var client = SQLClient.sharedInstance()
    
    var list_tmasrt: [TmasT] = []
    var listPermission: [ScreenPermesiion] = []

    var termBegin = ""
    var termEnd = ""
    
    
    
    var open_mang = 0
    var _cash = 0.0;
    var _bank = 0.0;
    var _t = 0.0;
    var loginUser = "admain"
    var currentIndex = 0
    var queryShow = ""
    var accessGrant = 0
    var query = ""
    var queryCheck = ""
    var queryKaz = ""
    let dateFormatter = DateFormatter()

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var showAllButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "تسجيل خروج", style: .plain, target: self, action: #selector(logOut))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate=self
        tableView.dataSource=self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePicker))
        toolBar.setItems([btnDone], animated: true)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "uk")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        print("Current date and time is: \(dateString)")
        start_date = dateString
        end_date = dateString
        
        
    }
    
    
    
    
    func showSnackBar(message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Snack Bar", body: message)
        view.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        SwiftMessages.show(config: config, view: view)
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
    
  
    

  
    @objc func logOut() {
        UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func closePicker(){
        view.endEditing(true)
       
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        client?.disconnect()
        print("disconnect")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return list_tmasrt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "t_masr_t_cell") as? TmasrTTableViewCell else { return UITableViewCell() }
        print(indexPath)
        

        cell.setupCell(dates:  list_tmasrt[indexPath.row].dates ?? "", cash:  list_tmasrt[indexPath.row].cash ?? 0, bank:  list_tmasrt[indexPath.row].bank ?? 0, t:  list_tmasrt[indexPath.row].t ?? 0)
        return cell
    }
    
    func connect()  {
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

            self.list_tmasrt.removeAll()
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
                            let instance = try JSONDecoder().decode(TmasT.self, from: jsonData)
                            self.list_tmasrt.append(instance)
                            self._cash += instance.cash ?? 0
                            self._bank += instance.bank ?? 0
                            self._t += instance.t ?? 0

                          
                           

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
    func connectCheckAcess()  {
        print(queryCheck)
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

            client.execute(self.queryCheck) { results in
                guard let result = results else {
                    print("error")
                    return
                }

                print(self.queryCheck)
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
                            let instance = try JSONDecoder().decode(Permissions.self, from: jsonData)
                            self.accessGrant = (instance.s ?? 0)
                                                    print("done")
                            if(self.accessGrant == 0){
                                self.showSnackBar(message: "no permission")
                            }else{
                                self.open_mang = 1
                            }
                            self.tableView.reloadData()
                            client.disconnect()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
       
        }

     func showAlertWithDetails(cash: Double,bank: Double,t: Double) {
         let formattedNumber = String(format: "%.2f", cash)
         let formattedNumber2 = String(format: "%.2f", bank)
         let formattedNumber3 = String(format: "%.2f", t)

        let message = """
          نقدي:\(formattedNumber)
          بنك:\(formattedNumber2)
         المبلغ:\(formattedNumber3)

        """
        let alert = UIAlertController(title: "الاجمالي", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func show_total(_ sender: Any) {
        showAlertWithDetails(cash: _cash, bank: _bank, t: _t)
    }
    
    @IBAction func checkAcess(_ sender: Any) {
        
         queryCheck = "select s from slahiat where n_perm = '" + loginUser + "' and no_forms = 201 "
        
        connectCheckAcess()
        
        

    }
    
   
    
    var start_date = ""
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        start_date = dateFormatter.string(from: sender.date)
        
        print("termBegin2")
        
        print(termBegin)
        print("start_date2")
        
        print(start_date)
        
    }
    var end_date = ""
    @IBAction func datePickerChanged2(sender: UIDatePicker) {
        end_date = dateFormatter.string(from: sender.date)
        
    }
  
    @IBAction func search(_ sender: Any) {
        print("search")
        
        _cash = 0.0;
        _bank = 0.0;
         _t = 0.0;
        
  
        if let startDate = dateFormatter.date(from: start_date),
           let endDate = dateFormatter.date(from: end_date),
           let termBeginDate = dateFormatter.date(from: termBegin),
           let termEndDate = dateFormatter.date(from: termEnd) {
            if (startDate < termBeginDate) || (startDate > termEndDate) {
                showSnackBar(message: "out of range")
            } else if (endDate < termBeginDate) || (endDate > termEndDate) {
                showSnackBar(message: "out of range")
            } else {
                
                if open_mang == 0 {
                    query =  "SELECT dates, SUM(cash) AS cash, SUM(bank) AS bank, SUM(t) AS t, ROW_NUMBER() OVER(ORDER BY dates) AS nn FROM t_masr WHERE dates Between '" + start_date + "' AND '" + end_date + "' AND mang = '0' GROUP BY dates ORDER BY dates"

                }else{
                    query  = "SELECT dates, SUM(cash) AS cash, SUM(bank) AS bank, SUM(t) AS t, ROW_NUMBER() OVER(ORDER BY dates) AS nn FROM t_masr WHERE dates Between '" + start_date + "' AND '" + end_date + "' GROUP BY dates ORDER BY dates"
                }
                
                
            }
            
          

            
            connect()
            tableView.reloadData()
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 600
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                
                if(self.list_tmasrt.isEmpty){
                    self.showSnackBar(message: "no data")
                }
            }
        }
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   
       
   

}


