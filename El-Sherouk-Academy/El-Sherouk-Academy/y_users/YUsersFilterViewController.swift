//
//  YUsersFilterViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 30/10/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class YUsersFilterViewController: UIViewController  ,UITextFieldDelegate  {
    var client: SQLClient?
    var usersList: [Users] = []
    var usersList1: [String] = []
    var nohMostantList: [NohMostand] = []
    var nohMostantList1: [String] = []
    var idMostand = ""

    
    
    var termBegin = ""
    var termEnd = ""
    var currentIndex = 0
    var query = ""
    
    
    
    
    let dateFormatter = DateFormatter()
    
    
    
    
    @IBOutlet weak var userFilter: DropDown!
    @IBOutlet weak var nohMostandFilter: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userFilter.addTarget(self, action: #selector(userdDidChange), for: .editingChanged)
        nohMostandFilter.addTarget(self, action: #selector(nohMostanddDidChange), for: .editingChanged)
       
        
        
    
        
        print("termBeginfff")
        
        print(termBegin)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "uk")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        print("Current date and time is: \(dateString)")
        start_date = dateString
        end_date = dateString
        searchForUser(_searchText: "")
        searchFornohMostand(_searchText: "")
        userFilter.backgroundColor = .white
        nohMostandFilter.backgroundColor = .white
        nohMostandFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        userFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

        
//        if #available(iOS 13.0, *) {
//                    overrideUserInterfaceStyle = .light // or .dark based on your preference
//                }
    }
//    func updateUIForCurrentTraitCollection() {
//            if #available(iOS 13.0, *) {
//                let isDarkMode = traitCollection.userInterfaceStyle == .dark
//
//                // Customize UI elements for dark mode
//                // For example, update background colors, text colors, etc.
//                nohMostandFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                nohMostandFilter.textColor = isDarkMode ? .white : .black
//                
//               
//                userFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                userFilter.textColor = isDarkMode ? .white : .black
//                
//               
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
//            }
//        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        client?.disconnect()
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
    
    
    func configureDropDownUser() {
        let  userNameList = self.usersList1
            userFilter.optionArray = userNameList

        userFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                
            }
            
       
          }
    func configureDropDownNohMostand() {
        let nohMostandList = self.nohMostantList1
            // Set up the Dropdown
            nohMostandFilter.optionArray = nohMostandList

            nohMostandFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.nohMostantList
                    .filter { $0.noh_mostand == selectedItem }
                    .compactMap { $0.cod_mostand }
                self.idMostand = filteredCodMostand.first ?? ""
                // Now you can use the filteredCodMostand array as needed.
                print(filteredCodMostand)
                print(self.idMostand)
            }
            
       
          }
    func searchFornohMostand(_searchText: String) {
        establishDBConnection()
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        nohMostantList.removeAll()
        let query2 = "SELECT top 10 noh_mostand  FROM noh_mostand_u WHERE noh_mostand LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(NohMostand.self, from: jsonData)
                        self.nohMostantList.append(instance)
                        self.nohMostantList1.append(instance.noh_mostand ?? "")

                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
       
    }
    
    func searchForUser(_searchText: String) {
        establishDBConnection()
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        usersList.removeAll()
        let query2 = "SELECT TOP 50 users FROM name_users_s WHERE users LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(Users.self, from: jsonData)
                        self.usersList.append(instance)
                        self.usersList1.append(instance.users ?? "")
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
       
    }
    
    
    
    
    @objc func nohMostanddDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = nohMostantList.filter { ($0.noh_mostand?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = nohMostantList.firstIndex { $0.noh_mostand == firstMatch.noh_mostand } ?? 0
                currentIndex = index
                //                if let studentName = firstMatch.n_cls {
                //                }
            }
        }
        searchFornohMostand(_searchText: searchText)
        configureDropDownNohMostand()
    }
    
    
    
    @objc func userdDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = usersList.filter { ($0.users?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = usersList.firstIndex { $0.users == firstMatch.users } ?? 0
                currentIndex = index
                
            }
        }
        searchForUser(_searchText: searchText)
        configureDropDownUser()
    }
    
    
    
    
    @objc func closePicker(){
        view.endEditing(true)
        
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
              
                 
                var x = ""
                x = "SELECT date_e,typ_e,dates,noh_mostand,mostand,n_trm,n_user,n_pc from y_users WHERE dates BETWEEN '" + start_date + "' AND '" + end_date + "'"

                if nohMostandFilter.text != "" {
                    x = x + " AND noh_mostand = '" + (nohMostandFilter.text ?? "")  + "'"

                }

                if userFilter.text != "" {
                    x = x + " AND n_user = '" + (userFilter.text ?? "")  + "'"

                }
                x = x + " ORDER BY no ASC"

                query = x
                 
               

                print (query)
                
            }
            
            
            
            if let navigationController = self.navigationController {
                if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? YstudbehvViewController {
                    previousViewController.query = query
                    print("on pop")
                    print(query)
                    navigationController.popViewController(animated: true)
                }
            }
        }
        
    }
}


