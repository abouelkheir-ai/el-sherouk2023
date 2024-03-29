//
//  YnewContFilterViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 31/10/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class YnewContFilterViewController: UIViewController  ,UITextFieldDelegate  {
    var client: SQLClient?
    
    var employeeList: [Employee] = []
    var employeeList1: [String] = []
    
    var usersList: [Users] = []
    var usersList1: [String] = []
    
    var saf_drasiList: [SafDrasi] = []
    var saf_drasiList1: [String] = []

    
    var noh_akdList = ["كورس", "شهري", "إسبوعي", "يومي"];
    let noh_invList = ["فاتورة مجموعة", "فاتورة فردي", "فاتورة باص"]
    var nohList = ["بنات","بنين"];
    
    var idCls = 0;
    var idEmployee = "";

    var termBegin = ""
    var termEnd = ""
    var currentIndex = 0
    var query = ""
    var switchOn = false
    
    let pickerUser = UIPickerView()
    let pickerInvoice = UIPickerView()
    let pickerAkd = UIPickerView()
    let pickerGen = UIPickerView()
    let pickerLevel = UIPickerView()
    let pickerEmployee = UIPickerView()

    
    
    let dateFormatter = DateFormatter()
    
    
    
    @IBOutlet weak var employeeFilter: DropDown!
    @IBOutlet weak var userFilter: DropDown!
    @IBOutlet weak var invoiceFilter: DropDown!
    @IBOutlet weak var akdFilter: DropDown!
    @IBOutlet weak var genFilter: DropDown!
    @IBOutlet weak var levelFilter: DropDown!
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeFilter.addTarget(self, action: #selector(employeedDidChange), for: .editingChanged)
        userFilter.addTarget(self, action: #selector(userdDidChange), for: .editingChanged)
        levelFilter.addTarget(self, action: #selector(saf_drasidDidChange), for: .editingChanged)

        
        
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
        
        invoiceFilter.optionArray = ["فاتورة مجموعة", "فاتورة فردي", "فاتورة باص"]
        invoiceFilter.didSelect { (selectedText , index ,id) in
               self.invoiceFilter.text = "Selected String: \(selectedText) \n index: \(index)"
           }
        genFilter.optionArray = ["بنات","بنين"];
        genFilter.didSelect { (selectedText , index ,id) in
            self.genFilter.text = "Selected String: \(selectedText) \n index: \(index)"
        }
        akdFilter.optionArray = ["كورس", "شهري", "إسبوعي", "يومي"]
        akdFilter.didSelect { (selectedText , index ,id) in
            self.akdFilter.text = "Selected String: \(selectedText) \n index: \(index)"
        }
        searchForUser(_searchText: "")
        searchForLevel(_searchText: "")
        searchForEmployee(_searchText: "")
        
        genFilter.backgroundColor = .white
        invoiceFilter.backgroundColor = .white
        userFilter.backgroundColor = .white
        levelFilter.backgroundColor = .white
        akdFilter.backgroundColor = .white
        employeeFilter.backgroundColor = .white
        
        genFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        invoiceFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        userFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        levelFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        akdFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        employeeFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

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
//                levelFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                levelFilter.textColor = isDarkMode ? .white : .black
//                
//               
//                userFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                userFilter.textColor = isDarkMode ? .white : .black
//                
//                employeeFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                employeeFilter.textColor = isDarkMode ? .white : .black
//                
//                akdFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                akdFilter.textColor = isDarkMode ? .white : .black
//                
//                invoiceFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                invoiceFilter.textColor = isDarkMode ? .white : .black
//                
//                genFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                genFilter.textColor = isDarkMode ? .white : .black
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
//            }
        }
    
    
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
    
    
    func configureDropDownEmployee() {
        let employeeNameList = self.employeeList1
            employeeFilter.optionArray = employeeNameList

        employeeFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.employeeList
                    .filter { $0.n_moz == selectedItem }
                    .compactMap { $0.id_moz }
                self.idEmployee = filteredCodMostand.first ?? ""
                print(filteredCodMostand)
                print(self.idEmployee)
            }
            
       
          }
    func configureDropDownLevel() {
       
        let levelList = self.saf_drasiList1
            // Set up the Dropdown
            levelFilter.optionArray = levelList

            levelFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.saf_drasiList
                    .filter { $0.n_cls == selectedItem }
                    .compactMap { $0.id_cls }
                self.idCls = Int(filteredCodMostand.first ?? 0)
                // Now you can use the filteredCodMostand array as needed.
                print(filteredCodMostand)
                print(self.idCls)
            }
        }
    
    func configureDropDownUser() {
     
        let userList = self.usersList1
            // Set up the Dropdown
            userFilter.optionArray = userList

            userFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
            }
        }
    
    func searchForLevel(_searchText: String) {
        establishDBConnection()
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        saf_drasiList.removeAll()
        let query2 = "SELECT TOP 10 n_cls, id_cls FROM name_cls WHERE n_cls LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(SafDrasi.self, from: jsonData)
                        self.saf_drasiList.append(instance)
                        self.saf_drasiList1.append(instance.n_cls ?? "")
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
                        self.usersList1.append(instance.users ?? "")
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
    
    
 
    
    
    
    @objc func saf_drasidDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = saf_drasiList.filter { ($0.n_cls?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = saf_drasiList.firstIndex { $0.n_cls == firstMatch.n_cls } ?? 0
                currentIndex = index
                //                if let studentName = firstMatch.n_cls {
                //                }
            }
        }
        searchForLevel(_searchText: searchText)
        configureDropDownLevel()
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
                x = "SELECT * FROM y_new_cont WHERE dates BETWEEN '" + start_date + "' AND '" + end_date + "'"

                if idEmployee != "" && employeeFilter.text != "" {
                    x = x + " AND users = '" + idEmployee + "'"

                }

                if userFilter.text != "" {
                    x = x + " AND users = '" + (userFilter.text ?? "") + "'"

                }

                if idCls != 0 && levelFilter.text != "" {
                    x = x + " AND id_cls = '" + String(idCls) + "'"

                }

                if invoiceFilter.text != "" {
                    x = x + " AND typ_inv = '" + (invoiceFilter.text ?? "") + "'"

                }

                if akdFilter.text != "" {
                    x = x + " AND typ_cont = '" + (akdFilter.text ?? "") + "'"

                }

                if genFilter.text != "" {
                    x = x + " AND gen = '" + (genFilter.text ?? "") + "'"

                }

                x = x + " ORDER BY td00 ASC"

                query = x

               
               
                
            }
            
            
            if let navigationController = self.navigationController {
                if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? YnewContViewController {
                    previousViewController.query = query
                    print("on pop")
                    print(query)
                    navigationController.popViewController(animated: true)
                }
            }
        }
    }
    
}


