//
//  YDiscInvFilterViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 01/11/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class YDiscInvFilterViewController: UIViewController  ,UITextFieldDelegate  {
    var client: SQLClient?
    
    
    var usersList: [Users] = []
    var users1List: [String] = []
    var userList: [Users] = []
    var user1List: [String] = []
    var employeeList: [Employee] = []
    var employeeList1: [String] = []
    var termBegin = ""
    var termEnd = ""
    var idEmployee = "";
    
    
    var currentIndex = 0
    var query = ""
    

    let dateFormatter = DateFormatter()
    
    
    @IBOutlet weak var userFilter: DropDown!
    @IBOutlet weak var employeeFilter: DropDown!
    @IBOutlet weak var usersSFilter: DropDown!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userFilter.addTarget(self, action: #selector(userdDidChange), for: .editingChanged)
        employeeFilter.addTarget(self, action: #selector(employeedDidChange), for: .editingChanged)
        usersSFilter.addTarget(self, action: #selector(usersdDidChange), for: .editingChanged)
        
                
        
            
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "uk")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        print("Current date and time is: \(dateString)")
        start_date = dateString
        end_date = dateString
        
        searchForUser(_searchText: "")
        searchForEmployee(_searchText: "")
        userFilter.backgroundColor = .white
        employeeFilter.backgroundColor = .white
        usersSFilter.backgroundColor = .white
        
        userFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        employeeFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        usersSFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

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
//             
//                
//               
//                userFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                userFilter.textColor = isDarkMode ? .white : .black
//                
//                employeeFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                employeeFilter.textColor = isDarkMode ? .white : .black
//                
//                usersSFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                usersSFilter.textColor = isDarkMode ? .white : .black
//                
//             
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
//            }
//        }
    func configureDropDownEmployee() {
            
            let emoloyee = self.employeeList1
                // Set up the Dropdown
                employeeFilter.optionArray = emoloyee

        employeeFilter.didSelect { (selectedItem, index, id) in
                    print("Selected item: \(selectedItem) at index \(index)")
                    let filteredCodMostand = self.employeeList
                        .filter { $0.n_moz == selectedItem }
                        .compactMap { $0.id_moz }
                    self.idEmployee = filteredCodMostand.first ?? ""
                    // Now you can use the filteredCodMostand array as needed.
                    print(filteredCodMostand)
                    print(self.idEmployee)
                }
            }
    func configureDropDownUser() {
     
        let userList = self.user1List
            // Set up the Dropdown
            userFilter.optionArray = userList

            userFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
            }
        }
    func configureDropDownUsers() {
     
        let usesrList = self.users1List
            // Set up the Dropdown
        usersSFilter.optionArray = usesrList

        usersSFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
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
    
    
    
    
    
    func searchForUser(_searchText: String) {
        establishDBConnection()
        guard let client = self.client else {
            print("Client not available")
            return
        }
        usersList.removeAll()
        let query2 = "SELECT TOP 10 users FROM name_user WHERE users LIKE '%\(_searchText)%'"
        
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
                        self.userList.append(instance)
                        self.user1List.append(instance.users ?? "")
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
       
    }
    func searchForUserS(_searchText: String) {
        establishDBConnection()
        guard let client = self.client else {
            print("Client not available")
            return
        }
        usersList.removeAll()
        let query2 = "SELECT TOP 10 users FROM name_users_s WHERE users LIKE '%\(_searchText)%'"
        
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
                        self.users1List.append(instance.users ?? "")
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
       
    }
    
    func searchForEmployee(_searchText: String) {
        establishDBConnection()
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        employeeList.removeAll()
        let query2 = "SELECT TOP 10 n_moz , id_moz FROM name_moz_rep WHERE n_moz LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(Employee.self, from: jsonData)
                        self.employeeList.append(instance)
                        self.employeeList1.append(instance.n_moz ?? "")
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
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
    @objc func usersdDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = usersList.filter { ($0.users?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = usersList.firstIndex { $0.users == firstMatch.users } ?? 0
                currentIndex = index
                
            }
        }
        searchForUserS(_searchText: searchText)
        configureDropDownUsers()
    }
    
    @objc func employeedDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = employeeList.filter { ($0.n_moz?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = employeeList.firstIndex { $0.n_moz == firstMatch.n_moz } ?? 0
                currentIndex = index
                
            }
        }
        searchForEmployee(_searchText: searchText)
        configureDropDownEmployee()
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
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
        dateFormatter.dateFormat = "yyyy-MM-dd"
        start_date = dateFormatter.string(from: sender.date)
        
        print("termBegin2")
        
        print(termBegin)
        print("start_date2")
        
        print(start_date)
        
    }
    var end_date = ""
    @IBAction func datePickerChanged2(sender: UIDatePicker) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        end_date = dateFormatter.string(from: sender.date)
        
    }
    
    
    
    
    
    
    @IBAction func passQuery(_ sender: Any) {
        print("button tapped")
        
        guard let startDate = dateFormatter.date(from: start_date),
              let endDate = dateFormatter.date(from: end_date),
              let termBeginDate = dateFormatter.date(from: termBegin),
              let termEndDate = dateFormatter.date(from: termEnd) else {
            print(start_date)
            print(end_date)
            print(termBegin)
            print(termEnd)

            print("Failed to convert dates")
            return
        }
        
        if (startDate < termBeginDate) || (startDate > termEndDate) {
            print("button tapped5")
            showSnackBar(message: "out of range")
        } else if (endDate < termBeginDate) || (endDate > termEndDate) {
            print("button tapped6")
            showSnackBar(message: "out of range")
        } else {
            print("button tapped7")
            var x = ""
            x = "SELECT * FROM y_disc_inv WHERE dates BETWEEN '" + start_date + "' AND '" + end_date + "'"
            
            if userFilter.text != "" {
                x = x + " AND user_k = '" + (userFilter.text ?? "")  + "'"
            }
            
            if employeeFilter.text != "" {
                x = x + " AND n_moz = '" + (employeeFilter.text ?? "") + "'"
            }
            
            if usersSFilter.text != "" {
                x = x + " AND user_inv = '" + (usersSFilter.text ?? "") + "'"
            }
            
            x = x + " ORDER BY td00 ASC"
            query = x
        }
        
        if let navigationController = self.navigationController {
            if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? YDiscViewController {
                previousViewController.query = query
                print("on pop")
                print(query)
                navigationController.popViewController(animated: true)
            }
        }
    }
}

