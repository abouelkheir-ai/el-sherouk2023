//
//  StAccFilterViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 08/11/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class StAccFilterViewController: UIViewController  ,UITextFieldDelegate  {
    var client: SQLClient?
    var name_acc: [Nacc] = []
    var name_acc1: [String] = []
    var acc_id = 0;
    var switchOn = false
    var termBegin = ""
    var termEnd = ""
    var lR = 0.0
    var currentIndex = 0
    var query = ""
    
    
    let dateFormatter = DateFormatter()
    
    
    
    
    
    @IBOutlet weak var accNameFilter: DropDown!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        accNameFilter.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        
          
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "تسجيل خروج", style: .plain, target: self, action: #selector(logOut))
        
            
        
        
          
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "uk")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        print("Current date and time is: \(dateString)")
        start_date = dateString
        end_date = dateString
        searchForAccName(_searchText: "")
        accNameFilter.backgroundColor = .white
        accNameFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

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
//                accNameFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                accNameFilter.textColor = isDarkMode ? .white : .black
//                
//                
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
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
    
    func configureDropDownAcc() {
            
            let accList = self.name_acc1
                // Set up the Dropdown
                accNameFilter.optionArray = accList

        accNameFilter.didSelect { (selectedItem, index, id) in
                    print("Selected item: \(selectedItem) at index \(index)")
                    let filteredCodMostand = self.name_acc
                        .filter { $0.n_acc == selectedItem }
                        .compactMap { $0.id_acc }
                    self.acc_id = Int(filteredCodMostand.first ?? 0)
                    // Now you can use the filteredCodMostand array as needed.
                    print(filteredCodMostand)
                    print(self.acc_id)
                }
            }
    
    func searchForAccName(_searchText: String) {
        establishDBConnection()
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        name_acc.removeAll()
        let query2 = " SELECT  TOP 10 n_acc , id_acc FROM name_acc  where n_acc like '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(Nacc.self, from: jsonData)
                        self.name_acc.append(instance)
                        self.name_acc1.append(instance.n_acc ?? "")
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
            let filteredBanks = name_acc.filter { $0.n_acc!.lowercased().contains(searchText.lowercased()) }
            if let firstMatch = filteredBanks.first {
                let index = name_acc.firstIndex { $0.id_acc == firstMatch.id_acc } ?? 0
                currentIndex = index
                acc_id = firstMatch.id_acc ?? 0
            }
        }
        searchForAccName(_searchText: searchText)
        configureDropDownAcc()
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
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        start_date = dateFormatter.string(from: sender.date)
        
        print("termBegin2")
        
        print(termBegin)
        print("start_date2")
        
        print(start_date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
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
                if accNameFilter.text == "" || acc_id == 0 {
                    // Handle the case where the bank name is empty or the ID is 0
                }
                    
                let queryLr = "SELECT SUM(rr) AS lr FROM bal_acc_s WHERE d < '\(start_date)' AND id_acc = '\(acc_id)'"
                               connectCheckLr(_lrQuery: queryLr) { lR in
                                   let lrString = String(format: "%.2f", lR)
                                   let finalQuery = "SELECT ISNULL(dates, '\(self.start_date)') AS dates, noh_mostand, cod_mostand, mostand, notes, madin, dain, user_s, td_s, user_e, td_e, id_trm, ISNULL(r, '\(lrString)') AS r FROM st_acc WHERE dates BETWEEN '\(self.start_date)' AND '\(self.end_date)' AND id_acc = '\(self.acc_id)' OR ((id_acc IS NULL) AND (ISNULL(r, '\(lrString)') <> '0')) ORDER BY td00 ASC"

                                   self.query = finalQuery
                                   self.performQuery()
                    }
            }
        }
    }
        func performQuery() {
            if let navigationController = self.navigationController {
                if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? StAccViewController {
                    previousViewController.query = self.query
                    print("on pop")
                    print(self.query)
                    navigationController.popViewController(animated: true)
                }
            }
        }
    
}


