//
//  NameStudNoFilterViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 08/11/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class NameStudNoFilterViewController: UIViewController  ,UITextFieldDelegate  {
    var client: SQLClient?
    
    
    var saf_drasiList: [SafDrasi] = []
    var saf_drasiList1: [String] = []
    
    var fatherList: [Father] = []
    var fatherList1: [String] = []
    
    var locationList: [Location] = []
    var locationList1: [String] = []
    
    var employeeList: [Employee] = []
    var employeeList1: [String] = []
    
    var repCallList: [NrepCall] = []
    var repCallList1: [String] = []

    var nohList = ["بنات","بنين"];
    var usersList: [Users] = []
    var usersList1: [String] = []

    
    
    var idCls = 0;
    var idsfather = 0;
    var idLocation = 0;
    var idrepCall = 0;
    var idUsers = 0;

    var idEmployee = "";
    var switchOn = false

    var termBegin = ""
    var termEnd = ""
    var currentIndex = 0
    var query = ""
    
    
   

    let dateFormatter = DateFormatter()
    
    
    
    
    @IBOutlet weak var levelFilter: DropDown!
    @IBOutlet weak var loacationFilter: DropDown!
    @IBOutlet weak var fatherFilter: DropDown!
    @IBOutlet weak var employeeFilter: DropDown!
    @IBOutlet weak var genFilter: DropDown!
    @IBOutlet weak var userFilter: DropDown!
    @IBOutlet weak var repCallFilter: DropDown!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelFilter.addTarget(self, action: #selector(saf_drasidDidChange), for: .editingChanged)
        loacationFilter.addTarget(self, action: #selector(locationdDidChange), for: .editingChanged)
        fatherFilter.addTarget(self, action: #selector(fatherdDidChange), for: .editingChanged)
        employeeFilter.addTarget(self, action: #selector(employeedDidChange), for: .editingChanged)
        userFilter.addTarget(self, action: #selector(userdDidChange), for: .editingChanged)
        
        repCallFilter.addTarget(self, action: #selector(repCallDidChange), for: .editingChanged)
    
        
        genFilter.optionArray = ["بنات","بنين"];
        genFilter.didSelect { (selectedText , index ,id) in
            self.genFilter.text = "Selected String: \(selectedText) \n index: \(index)"
        }
        
       
        

        
        
        
       
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
        searchForArea(_searchText: "")
        searchForCALL(_searchText: "")
        searchForUser(_searchText: "")
        searchForLevel(_searchText: "")
        searchForFather(_searchText: "")
        searchForEmployee(_searchText: "")
        
        loacationFilter.backgroundColor = .white
        repCallFilter.backgroundColor = .white
        userFilter.backgroundColor = .white
        levelFilter.backgroundColor = .white
        fatherFilter.backgroundColor = .white
        employeeFilter.backgroundColor = .white
        
        
        loacationFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        repCallFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        userFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        levelFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        fatherFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
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
//                employeeFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                employeeFilter.textColor = isDarkMode ? .white : .black
//                
//                userFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                userFilter.textColor = isDarkMode ? .white : .black
//                
//                fatherFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                fatherFilter.textColor = isDarkMode ? .white : .black
//                
//                genFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                genFilter.textColor = isDarkMode ? .white : .black
//                
//                repCallFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                repCallFilter.textColor = isDarkMode ? .white : .black
//                
//                loacationFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                loacationFilter.textColor = isDarkMode ? .white : .black
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
//            }
        }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            updateUIForCurrentTraitCollection()
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
    func configureDropDownFather() {
            
            let fatherList = self.fatherList1
                // Set up the Dropdown
                fatherFilter.optionArray = fatherList

        fatherFilter.didSelect { (selectedItem, index, id) in
                    print("Selected item: \(selectedItem) at index \(index)")
                    let filteredCodMostand = self.fatherList
                        .filter { $0.n_f_stud == selectedItem }
                        .compactMap { $0.id_f_stud }
                    self.idsfather = Int(filteredCodMostand.first ?? 0)
                    // Now you can use the filteredCodMostand array as needed.
                    print(filteredCodMostand)
                    print(self.idsfather)
                }
            }
    func configureDropDownLocation() {
            
            let location = self.locationList1
                // Set up the Dropdown
                loacationFilter.optionArray = location

        loacationFilter.didSelect { (selectedItem, index, id) in
                    print("Selected item: \(selectedItem) at index \(index)")
                    let filteredCodMostand = self.locationList
                        .filter { $0.n_area == selectedItem }
                        .compactMap { $0.id_area }
                    self.idLocation = Int(filteredCodMostand.first ?? 0)
                    // Now you can use the filteredCodMostand array as needed.
                    print(filteredCodMostand)
                    print(self.idLocation)
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
    
    func configureDropDownEmployee() {
            
            let employee = self.employeeList1
                // Set up the Dropdown
                employeeFilter.optionArray = employee

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
    func configureDropDownrepcall() {
            
            let repCall = self.repCallList1
                // Set up the Dropdown
                repCallFilter.optionArray = repCall

        repCallFilter.didSelect { (selectedItem, index, id) in
                    print("Selected item: \(selectedItem) at index \(index)")
                    let filteredCodMostand = self.repCallList
                        .filter { $0.n_rep_call == selectedItem }
                        .compactMap { $0.id_rep_call }
                    self.idrepCall = Int(filteredCodMostand.first ?? 0)
                    // Now you can use the filteredCodMostand array as needed.
                    print(filteredCodMostand)
                    print(self.idrepCall)
                }
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
    
    
    func searchForCALL(_searchText: String) {
        establishDBConnection()
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        repCallList.removeAll()
        let query2 = "SELECT TOP 10 n_rep_call , id_rep_call FROM name_rep_call WHERE n_rep_call LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(NrepCall.self, from: jsonData)
                        self.repCallList.append(instance)
                        self.repCallList1.append(instance.n_rep_call ?? "")
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
       
    }
    @objc func repCallDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = repCallList.filter { ($0.n_rep_call?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = repCallList.firstIndex { $0.n_rep_call == firstMatch.n_rep_call } ?? 0
                currentIndex = index
                
            }
        }
        searchForCALL(_searchText: searchText)
        configureDropDownrepcall()
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
    
   
    
    func searchForFather(_searchText: String) {
        establishDBConnection()
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        fatherList.removeAll()
        let query2 = "SELECT TOP 10 n_f_stud , id_f_stud FROM name_f_stud WHERE n_f_stud LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(Father.self, from: jsonData)
                        self.fatherList.append(instance)
                        self.fatherList1.append(instance.n_f_stud ?? "" )
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        
    }
    
    func searchForArea(_searchText: String) {
        establishDBConnection()
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        locationList.removeAll()
        let query2 = "SELECT TOP 10 n_area , id_area FROM name_area WHERE n_area LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(Location.self, from: jsonData)
                        self.locationList.append(instance)
                        self.locationList1.append(instance.n_area ?? "")
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
    
    
    
    
    
    @objc func fatherdDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = fatherList.filter { ($0.n_f_stud?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = fatherList.firstIndex { $0.n_f_stud == firstMatch.n_f_stud } ?? 0
                currentIndex = index

                
            }
        }
        searchForFather(_searchText: searchText)
        configureDropDownFather()
    }
    @objc func locationdDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = locationList.filter { ($0.n_area?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = locationList.firstIndex { $0.n_area == firstMatch.n_area } ?? 0
                currentIndex = index
                
            }
        }
        searchForArea(_searchText: searchText)
        configureDropDownLocation()
    }
    
    
    
    
    @objc func closePicker(){
        view.endEditing(true)
        
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
    
    
   
    @IBAction func switchChange(_ sender: UISwitch) {
        if sender.isOn {
            switchOn = true
        } else {
            switchOn = false
        }
        print(switchOn)  }
    
    
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
                
                var y = ""
                
                if switchOn {
                    
                    y = "id_f_stud, "
                }
                 
               

                var  x  = ""
                x = "SELECT *, ROW_NUMBER() OVER(ORDER BY " + y + "dates, id_stud) AS nn FROM name_stud_no_cont WHERE dates BETWEEN '" + start_date + "' AND '" + end_date + "'"

                if idCls != 0  && levelFilter.text != "" {
                    x = x + " AND id_cls = '" + String(idCls) + "'"

                }

                if idEmployee != "" && employeeFilter.text != ""  {
                    x = x + " AND id_moz = '" + idEmployee + "'"

                }

                if userFilter.text != "" {
                    x = x + " AND users = '" + (userFilter.text ?? "") + "'"

                }

                if genFilter.text != "" {
                    x = x + " AND gen = '" + (genFilter.text ?? "") + "'"

                }

                if idrepCall != 0 && repCallFilter.text != "" {
                    x = x + " AND id_rep_call = '" + String(idrepCall) + "'"

                }

                if idLocation != 0 && loacationFilter.text != "" {
                    x = x + " AND id_area = '" + String(idLocation) + "'"

                }

                if idsfather != 0 && fatherFilter.text != "" {
                    x = x + " AND id_f_stud = '" + String(idsfather) + "'"

                }

                x = x + " ORDER BY " + y + "dates, id_stud ASC"

                

                query = x
                
                
            }
            
            
            if let navigationController = self.navigationController {
                if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? NameStudNoViewController {
                    previousViewController.query = query
                    print("on pop")
                    print(query)
                    navigationController.popViewController(animated: true)
                }
            }
        }
    }
    
}

