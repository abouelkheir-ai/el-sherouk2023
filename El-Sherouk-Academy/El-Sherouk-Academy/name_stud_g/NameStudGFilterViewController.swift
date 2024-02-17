//
//  NameStudGFilterViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 08/11/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class NameStudGFilterViewController: UIViewController  ,UITextFieldDelegate  {
    var client: SQLClient?
    
    
    var saf_drasiList: [SafDrasi] = []
    var saf_drasiList1: [String] = []
    
    var employeeList: [Employee] = []
    var employeeList1: [String] = []
    
    var govList: [Gov] = []
    var govList1: [String] = []
    
    var fatherList: [Father] = []
    var fatherList1: [String] = []
    
    var usersList: [Users] = []
    var usersList1: [String] = []
    
    var schoolList: [Nschool] = []
    var schoolList1: [String] = []
    
    var nohList = ["بنات","بنين"];
    var noh_akdList = ["كورس", "شهري", "إسبوعي", "يومي"];
    
    var mada: [Mada] = []
    var mada1: [String] = []

    var idMada = 0 ;
    var idCls = 0;
    var idsfather = 0;
    var idGov = 0;

    var idEmployee = "";
    var idSchool = 0;
    var switchOn = false

    var termBegin = ""
    var termEnd = ""
    var currentIndex = 0
    var query = ""
    
    
   

    let dateFormatter = DateFormatter()
    
    
    
    
    @IBOutlet weak var levelFilter: DropDown!
    @IBOutlet weak var fatherFilter: DropDown!
    @IBOutlet weak var employeeFilter: DropDown!
    @IBOutlet weak var govFilter: DropDown!
    @IBOutlet weak var userFilter: DropDown!
    @IBOutlet weak var genFilter: DropDown!
    @IBOutlet weak var akdFilter: DropDown!
    @IBOutlet weak var madaFilter: DropDown!
    @IBOutlet weak var schoolFilter: DropDown!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        madaFilter.addTarget(self, action: #selector(madadDidChange), for: .editingChanged)

        levelFilter.addTarget(self, action: #selector(saf_drasidDidChange), for: .editingChanged)
        fatherFilter.addTarget(self, action: #selector(fatherdDidChange), for: .editingChanged)
        employeeFilter.addTarget(self, action: #selector(employeedDidChange), for: .editingChanged)
        govFilter.addTarget(self, action: #selector(govDidChange), for: .editingChanged)

        userFilter.addTarget(self, action: #selector(userdDidChange), for: .editingChanged)
        schoolFilter.addTarget(self, action: #selector(schoolDidChange), for: .editingChanged)
      
             print(termBegin)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "uk")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        print("Current date and time is: \(dateString)")
        start_date = dateString
        end_date = dateString
        
        akdFilter.optionArray = ["كورس", "شهري", "إسبوعي", "يومي"];
        akdFilter.didSelect { (selectedText , index ,id) in
               self.akdFilter.text = "Selected String: \(selectedText) \n index: \(index)"
           }
        genFilter.optionArray = ["بنات","بنين"];
        genFilter.didSelect { (selectedText , index ,id) in
            self.genFilter.text = "Selected String: \(selectedText) \n index: \(index)"
        }
        
        searchForGov(_searchText: "")
        searchForMada(_searchText: "")
        searchForUser(_searchText: "")
        searchForLevel(_searchText: "")
        searchForFather(_searchText: "")
        searchForSchool(_searchText: "")
        searchForEmployee(_searchText: "")
        
        govFilter.backgroundColor = .white
        madaFilter.backgroundColor = .white
        userFilter.backgroundColor = .white
        levelFilter.backgroundColor = .white
        fatherFilter.backgroundColor = .white
        schoolFilter.backgroundColor = .white
        employeeFilter.backgroundColor = .white
        
        govFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        madaFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        userFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        levelFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        fatherFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        schoolFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
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
//                akdFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                akdFilter.textColor = isDarkMode ? .white : .black
//                
//                govFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                govFilter.textColor = isDarkMode ? .white : .black
//                schoolFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                schoolFilter.textColor = isDarkMode ? .white : .black
//                
//                madaFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                madaFilter.textColor = isDarkMode ? .white : .black
//             
//                fatherFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                fatherFilter.textColor = isDarkMode ? .white : .black
//                
//                genFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                genFilter.textColor = isDarkMode ? .white : .black
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
//            }
        }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            updateUIForCurrentTraitCollection()
        }
    func configureDropDownSchool() {
       
        let school = self.schoolList1
            // Set up the Dropdown
            schoolFilter.optionArray = school

        schoolFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.schoolList
                    .filter { $0.n_school == selectedItem }
                    .compactMap { $0.id_school }
                self.idSchool = Int(filteredCodMostand.first ?? 0)
                // Now you can use the filteredCodMostand array as needed.
                print(filteredCodMostand)
                print(self.idSchool)
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
    func configureDropDownMada() {
       
        let mada = self.mada1
            // Set up the Dropdown
            madaFilter.optionArray = mada

        madaFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.mada
                    .filter { $0.n_sub == selectedItem }
                    .compactMap { $0.id_sub }
                self.idMada = Int(filteredCodMostand.first ?? 0)
                // Now you can use the filteredCodMostand array as needed.
                print(filteredCodMostand)
                print(self.idMada)
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
    func configureDropDownArea() {
            
            let area = self.govList1
                // Set up the Dropdown
                govFilter.optionArray = area

        govFilter.didSelect { (selectedItem, index, id) in
                    print("Selected item: \(selectedItem) at index \(index)")
                    let filteredCodMostand = self.govList
                        .filter { $0.n_gov == selectedItem }
                        .compactMap { $0.id_gov }
                    self.idGov = Int(filteredCodMostand.first ?? 0)
                    // Now you can use the filteredCodMostand array as needed.
                    print(filteredCodMostand)
                    print(self.idGov)
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
    func searchForSchool(_searchText: String) {
        establishDBConnection()
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        schoolList.removeAll()
        let query2 = "SELECT TOP 10 n_school , id_school FROM name_school WHERE n_school LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(Nschool.self, from: jsonData)
                        self.schoolList.append(instance)
                        self.schoolList1.append(instance.n_school ?? "")
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
      
    }
    @objc func schoolDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = schoolList.filter { ($0.n_school?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = schoolList.firstIndex { $0.n_school == firstMatch.n_school } ?? 0
                currentIndex = index
                
            }
        }
        searchForSchool(_searchText: searchText)
        configureDropDownSchool()
    }
    func searchForMada(_searchText: String) {
        establishDBConnection()

        guard let client = self.client else {
            print("Client not available")
            return
        }
        mada.removeAll()
        let query2 = "SELECT TOP 10 n_sub , id_sub FROM name_sub WHERE n_sub LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(Mada.self, from: jsonData)
                        self.mada.append(instance)
                        self.mada1.append(instance.n_sub ?? "")
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        
    }
    
    @objc func madadDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = mada.filter { ($0.n_sub?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = mada.firstIndex { $0.n_sub == firstMatch.n_sub } ?? 0
                currentIndex = index
                
            }
        }
        searchForMada(_searchText: searchText)
        configureDropDownMada()
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
    func searchForGov(_searchText: String) {
        establishDBConnection()
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        govList.removeAll()
        let query2 = "SELECT TOP 10 n_gov , id_gov FROM name_gov WHERE n_gov LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(Gov.self, from: jsonData)
                        self.govList.append(instance)
                        self.govList1.append(instance.n_gov ?? "" )
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
      
    }
    
    @objc func govDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = govList.filter { ($0.n_gov?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = govList.firstIndex { $0.n_gov == firstMatch.n_gov } ?? 0
                currentIndex = index
                
            }
        }
        searchForGov(_searchText: searchText)
        configureDropDownArea()
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
                        self.fatherList1.append(instance.n_f_stud ?? "")
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

                var x = ""
                
                x = "SELECT n_cls, n_stud, id_f_stud, gen, tel_m, n_school, n_gov, users, d_f, d_t, user_s, td_s, user_e, td_e, mostand, cod_mostand, id_trm, ROW_NUMBER() OVER(ORDER BY " + y + "n_cls) AS nn FROM name_stud_g WHERE d_f <= '" + start_date + "' AND d_t >= '" + end_date + "'"

                if idCls != 0 && levelFilter.text != ""{
                    x = x + " AND id_cls = '" + String(idCls) + "'"

                }

                if userFilter.text != "" {
                    x = x + " AND users = '" + (userFilter.text ?? "") + "'"

                }

                if idEmployee != "" && employeeFilter.text != "" {
                    x = x + " AND id_moz = '" + idEmployee + "'"

                }

                if genFilter.text != "" {
                    x = x + " AND gen = '" + (genFilter.text ?? "") + "'"

                }

                if idMada != 0 && madaFilter.text != "" {
                    
                    x = x + " AND id_sub = '" + String(idMada) + "'"

                }

                if akdFilter.text !=  "" {
                    
                    x = x + " AND typ_cont = '" + (akdFilter.text ?? "") + "'"

                }

                if idSchool != 0 && schoolFilter.text != "" {
                    x = x + " AND id_school = '" + String(idSchool) + "'"

                }

                if idGov != 0 && govFilter.text != "" {
                    x = x + " AND id_gov = '" + String(idGov) + "'"
                    
                }

                if idsfather != 0 &&  fatherFilter.text != "" {
                    x = x + " AND id_f_stud = '" + String(idsfather) + "'"

                }

                x = x + " GROUP BY n_cls, n_stud, id_f_stud, gen, tel_m, n_school, n_gov, users, d_f, d_t, user_s, td_s, user_e, td_e, mostand, cod_mostand, id_trm ORDER BY " + y + "n_cls ASC"

                query = x

                
                
                
                
            }
            
            
            if let navigationController = self.navigationController {
                if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? NameStudGViewController {
                    previousViewController.query = query
                    print("on pop")
                    print(query)
                    navigationController.popViewController(animated: true)
                }
            }
        }
    }
    
}


