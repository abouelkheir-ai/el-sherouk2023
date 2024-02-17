//
//  STbankTFilterViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 08/11/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class STbankTFilterViewController: UIViewController  ,UITextFieldDelegate  {
    var client: SQLClient?
    var bank_name: [BankName] = []
    var bank_name1: [String] = []

    var bank_id = 0;
    var switchOn = false
    var termBegin = ""
    var termEnd = ""
    var lR = 0.0
    var currentIndex = 0
    var query = ""
    
    
    let dateFormatter = DateFormatter()
    
    
    
    
    
    @IBOutlet weak var bankNameFilter: DropDown!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        bankNameFilter.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        
      
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "تسجيل خروج", style: .plain, target: self, action: #selector(logOut))
        
                
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "uk")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        print("Current date and time is: \(dateString)")
        start_date = dateString
        end_date = dateString
        searchForBankName(_searchText: "")
        bankNameFilter.backgroundColor = .white
        bankNameFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

//        if #available(iOS 13.0, *) {
//                    overrideUserInterfaceStyle = .light // or .dark based on your preference
//                }
    }
    func updateUIForCurrentTraitCollection() {
//            if #available(iOS 13.0, *) {
//                let isDarkMode = traitCollection.userInterfaceStyle == .dark
//
//                // Customize UI elements for dark mode
//                // For example, update background colors, text colors, etc.
//                bankNameFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                bankNameFilter.textColor = isDarkMode ? .white : .black
//                
//              
//               
//            }
        }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            updateUIForCurrentTraitCollection()
        }
    
    @objc func logOut() {
        UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func configureDropDownBankName() {
            
            let bankList = self.bank_name1
                // Set up the Dropdown
                bankNameFilter.optionArray = bankList

        bankNameFilter.didSelect { (selectedItem, index, id) in
                    print("Selected item: \(selectedItem) at index \(index)")
                    let filteredCodMostand = self.bank_name
                        .filter { $0.n_acc == selectedItem }
                        .compactMap { $0.id_acc }
                    self.bank_id = Int(filteredCodMostand.first ?? 0)
                    // Now you can use the filteredCodMostand array as needed.
                    print(filteredCodMostand)
                    print(self.bank_id)
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
    
    
    
    func searchForBankName(_searchText: String) {
        establishDBConnection()
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        bank_name.removeAll()
        let query2 = " SELECT  TOP 50 n_acc , id_acc FROM name_bank  where n_acc like '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(BankName.self, from: jsonData)
                        self.bank_name.append(instance)
                        self.bank_name1.append(instance.n_acc ?? "")
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
       
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredBanks = bank_name.filter { $0.n_acc!.lowercased().contains(searchText.lowercased()) }
            if let firstMatch = filteredBanks.first {
                let index = bank_name.firstIndex { $0.id_acc == firstMatch.id_acc } ?? 0
                currentIndex = index
                bank_id = firstMatch.id_acc ?? 0
            }
        }
        searchForBankName(_searchText: searchText)
        configureDropDownBankName()
        }
    
    
    
    
    
    
    
    
    
    
    @objc func closePicker(){
        view.endEditing(true)
        
        
    }
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        client?.disconnect()
        print("disconnect")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   
    
    
    
    
    
    
    func showSnackBar(message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Snack Bar", body: message)
        view.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        SwiftMessages.show(config: config, view: view)
    }
    
    var start_date = ""
    var d3: String = ""
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        start_date = dateFormatter.string(from: sender.date)
        
        print("termBegin2")
        
        print(termBegin)
        print("start_date2")
        
        print(start_date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        d3 = dateFormatter.string(from: sender.date)
        
        // Get the previous day
        if let selectedDate = dateFormatter.date(from: d3) {
            if let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) {
                let previousDateString = dateFormatter.string(from: previousDate)
                print("Previous day: \(previousDateString)")
                d3 = previousDateString
            }
        }
    }
    
    
    var end_date = ""
    @IBAction func datePickerChanged2(sender: UIDatePicker) {
        end_date = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func switchChange(_ sender: UISwitch) {
        if sender.isOn {
            switchOn = true
        } else {
            switchOn = false
        }
        print(switchOn)  }
    func connectCheckLr(_lrQuery : String, completion: @escaping (Double) -> Void)  {
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
        
        client.execute(_lrQuery) { results in
            guard let result = results else {
                print("error")
                return
            }
            
            print(_lrQuery)
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
                        let instance = try JSONDecoder().decode(LR.self, from: jsonData)
                        self.lR += (instance.lr ?? 0)
                        print(self.lR)
                        completion(self.lR)
                        
                        print("done")
                        
                        client.disconnect()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
    }
    @IBAction func passQuery(_ sender: Any) {
        if let startDate = dateFormatter.date(from: start_date),
           let endDate = dateFormatter.date(from: end_date),
           let termBeginDate = dateFormatter.date(from: termBegin),
           let termEndDate = dateFormatter.date(from: termEnd) {
            if (startDate < termBeginDate) || (startDate > termEndDate) {
                showSnackBar(message: "out of range")
            } else if (endDate < termBeginDate) || (endDate > termEndDate) {
                showSnackBar(message: "out of range")
            } else {
                if bankNameFilter.text == "" || bank_id == 0 {
                    // Handle the case where the bank name is empty or the ID is 0
                }
                if switchOn {
                    
                    let queryLr = "SELECT SUM(rr) AS lr FROM bal_acc_uc WHERE d < '" + start_date + "' AND id_acc = '" + String(bank_id) + "'"
                    
                    connectCheckLr(_lrQuery: queryLr) { lR in
                        self.query = "SELECT ISNULL(dates, '" + self.d3 + "') AS dates, madin, dain, ISNULL((SELECT SUM(r) AS r FROM st_bank_uc_t AS st_bank_uc_t_1 WHERE (st_bank_uc_t.id_acc = id_acc) AND (st_bank_uc_t.dates >= dates)), '" + String(lR) + "') AS r, ROW_NUMBER() OVER(ORDER BY dates) AS nn FROM st_bank_uc_t WHERE (ISNULL((SELECT SUM(r) AS r FROM st_bank_uc_t AS st_bank_uc_t_1 WHERE (st_bank_uc_t.id_acc = id_acc) AND (st_bank_uc_t.dates >= dates)), '" + String(lR) + "') <> 0) AND (dates Between '" + self.start_date + "' AND '" + self.end_date + "' AND id_acc = '" + String(self.bank_id) + "' OR (id_acc IS NULL)) ORDER BY dates ASC"
                        self.performQuery()
                    }
                } else {
                    
                    let queryLr  =  "SELECT SUM(rr) AS lr FROM bal_acc_s WHERE d < '" + start_date + "' AND id_acc = '" + String(bank_id) + "'"
                    connectCheckLr(_lrQuery: queryLr) { lR in
                        self.query =  "SELECT ISNULL(dates, '" + self.d3 + "') AS dates, madin, dain, ISNULL(r, '" + String(lR) + "') AS r, ROW_NUMBER() OVER(ORDER BY dates) AS nn FROM st_bank_t WHERE (ISNULL(r, '" + String(lR) + "') <> 0) AND (dates Between '" + self.start_date + "' AND '" + self.end_date + "' AND id_acc = '" + String(self.bank_id) + "' OR (id_acc IS NULL)) ORDER BY dates ASC"
                        self.performQuery()
                    }
                }
            }
        }
    }
        func performQuery() {
            if let navigationController = self.navigationController {
                if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? StBankTViewController {
                    previousViewController.query = self.query
                    print("on pop")
                    print(self.query)
                    navigationController.popViewController(animated: true)
                }
            }
        }
    
}
