//
//  StKazFilterViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 07/11/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class StKazFilterViewController: UIViewController ,UITextFieldDelegate {
    var client = SQLClient.sharedInstance()
    
    
    var kazList: [KazName] = []
    var kazList1: [String] = []

    var kaz_id = 0;
    var open_mang = 0
    var accessGrant = 0
    var loginUser = "admain"
    var currentIndex = 0
    var query = ""
    var queryCheck = ""
    var queryKaz = ""
    var queryLr = ""
    var termBegin = ""
    var termEnd = ""
    let dateFormatter = DateFormatter()
    
    var lR = 0.0
    
    @IBOutlet weak var datePickerStart: UIDatePicker!
    @IBOutlet weak var datePickerEnd: UIDatePicker!
    
    @IBOutlet weak var kazNameFilter: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kazNameFilter.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "تسجيل خروج", style: .plain, target: self, action: #selector(logOut))
        
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
        searchForKaz(_searchText: "")
        
        kazNameFilter.backgroundColor = .white
        kazNameFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

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
//                kazNameFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                kazNameFilter.textColor = isDarkMode ? .white : .black
//               
//            }
        }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            updateUIForCurrentTraitCollection()
        }
    func configureDropDownSafe() {
            
            let safeList = self.kazList1
                // Set up the Dropdown
                kazNameFilter.optionArray = safeList

        kazNameFilter.didSelect { (selectedItem, index, id) in
                    print("Selected item: \(selectedItem) at index \(index)")
                    let filteredCodMostand = self.kazList
                        .filter { $0.n_acc == selectedItem }
                        .compactMap { $0.id_acc }
                    self.kaz_id = Int(filteredCodMostand.first ?? 0)
                    // Now you can use the filteredCodMostand array as needed.
                    print(filteredCodMostand)
                    print(self.kaz_id)
                }
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
    func searchForKaz(_searchText: String) {
        establishDBConnection()
        
        if(accessGrant == 0){
            queryKaz  = "SELECT TOP 10 n_acc , id_acc FROM name_kaz WHERE  mang = 0 and n_acc  LIKE '%\(_searchText)%'"
            
        }else{
            queryKaz = "SELECT TOP 50 n_acc , id_acc FROM name_kaz WHERE n_acc  LIKE '%\(_searchText)%'"
        }
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        kazList.removeAll()
        print (queryKaz)
        client.execute(queryKaz) { results in
            guard let result = results else {
                print("Error retrieving data")
                return
            }
            
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
                        let instance = try JSONDecoder().decode(KazName.self, from: jsonData)
                        self.kazList.append(instance)
                        self.kazList1.append(instance.n_acc ?? "")
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
            let filteredkaz = kazList.filter { $0.n_acc!.lowercased().contains(searchText.lowercased()) }
            if let firstMatch = filteredkaz.first {
                let index = kazList.firstIndex { $0.id_acc == firstMatch.id_acc } ?? 0
                currentIndex = index
                kaz_id = firstMatch.id_acc ?? 0
            }
        }
        searchForKaz(_searchText: searchText)
        configureDropDownSafe()
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
                            self.datePickerStart.isEnabled = true
                            self.datePickerEnd.isEnabled = true
                        }
                        client.disconnect()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
    }
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
    @IBAction func checkAcess(_ sender: Any) {
        
        queryCheck = "select s from slahiat where n_perm = '" + loginUser + "' and no_forms = 201 "
        
        connectCheckAcess()
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kazList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return kazList[row].n_acc
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentIndex = row
        kaz_id = kazList[row].id_acc ?? 0
        kazNameFilter.text = kazList[row].n_acc
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
                
                if(kazNameFilter.text == "" || kaz_id == 0){
                    print("no kaz name or id")
                }else{
                    queryLr = "SELECT SUM(rr) AS lr FROM bal_acc_s WHERE d < '" + start_date + "' AND id_acc = '" + String(kaz_id) + "'"
                    
                    connectCheckLr(_lrQuery: queryLr) { lR in
                        self.query = "SELECT ISNULL(dates, '" + self.start_date + "') AS dates, noh_mostand, cod_mostand, mostand, hh, notes, madin, dain, user_s, td_s, user_e, td_e, id_trm, ISNULL(r, '" + String(lR) + "') AS r FROM st_kaz WHERE (dates Between '" + self.start_date + "' AND '" + self.end_date + "' AND id_acc = '" + String(self.kaz_id) + "') OR ((id_acc IS NULL) AND (ISNULL(r, '" + String(lR) + "') <> '0')) ORDER BY td00 ASC"
                        if let navigationController = self.navigationController {
                            if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? StKazViewControllerr {
                                previousViewController.query = self.query
                                print("on pop")
                                print(self.query)
                                navigationController.popViewController(animated: true)
                            }
                        }
                    }
                }
              
            }
        }
    }
}
