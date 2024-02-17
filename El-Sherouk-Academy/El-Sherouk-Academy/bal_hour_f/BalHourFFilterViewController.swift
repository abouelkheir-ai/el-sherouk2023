//
//  BalHourFViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 26/10/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class BalHourFFilterViewController: UIViewController  ,UITextFieldDelegate  {
    var client: SQLClient?
    
    var stud_name: [StudentName] = []
    var stud_name1: [String] = []
    var saf_drasi: [SafDrasi] = []
    var saf_drasi1: [String] = []
    var mada: [Mada] = []
    var mada1: [String] = []
    var usersList: [Users] = []
    var usersList1: [String] = []
    var fatherList: [Father] = []
    var fatherList1: [String] = []
    
    var idStud = 0;
    var idCls = 0;
    var idstub = 0;
    var idsfather = 0;
    var termBegin = ""
    var termEnd = ""
    var currentIndex = 0
    var query = ""
    var switchOn = false
    
    let dateFormatter = DateFormatter()


    
    
    @IBOutlet weak var studentNameFilter: DropDown!
    
    @IBOutlet weak var levelFilter: DropDown!
    
    @IBOutlet weak var madaFilter: DropDown!
    
    @IBOutlet weak var fatherFilter: DropDown!
    @IBOutlet weak var userFilter: DropDown!
    
    @IBOutlet weak var switchCheck: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        studentNameFilter.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        levelFilter.addTarget(self, action: #selector(saf_drasidDidChange), for: .editingChanged)
        madaFilter.addTarget(self, action: #selector(madadDidChange), for: .editingChanged)
        userFilter.addTarget(self, action: #selector(userdDidChange), for: .editingChanged)
        fatherFilter.addTarget(self, action: #selector(fatherdDidChange), for: .editingChanged)
  
        
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
        
        searchForMada(_searchText: "")
        searchForUser(_searchText: "")
        searchForFather(_searchText: "")
        searchForStudent(_searchText: "")
        searchForLevel(_searchText: "")
        
        madaFilter.backgroundColor = .white
        userFilter.backgroundColor = .white
        levelFilter.backgroundColor = .white
        fatherFilter.backgroundColor = .white
        studentNameFilter.backgroundColor = .white
        
        madaFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        userFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        levelFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        fatherFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        studentNameFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

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
//                levelFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                levelFilter.textColor = isDarkMode ? .white : .black
//                
//               
//                userFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                userFilter.textColor = isDarkMode ? .white : .black
//                
//                madaFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                madaFilter.textColor = isDarkMode ? .white : .black
//                
//                studentNameFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                studentNameFilter.textColor = isDarkMode ? .white : .black
//                
//                fatherFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                fatherFilter.textColor = isDarkMode ? .white : .black
//                
//             
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
//            }
//        }
   
    
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
    
    
    func configureDropDownStudent() {
        let studentNameList = self.stud_name1
            studentNameFilter.optionArray = studentNameList

        studentNameFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.stud_name
                    .filter { $0.n_stud == selectedItem }
                    .compactMap { $0.id_stud }
                self.idStud = Int(filteredCodMostand.first ?? 0)
                print(filteredCodMostand)
                print(self.idStud)
            }
            
       
          }
    func configureDropDownFather() {
        let fatherNameList = self.fatherList1
            fatherFilter.optionArray = fatherNameList

        fatherFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.fatherList
                    .filter { $0.n_f_stud == selectedItem }
                    .compactMap { $0.id_f_stud }
                self.idsfather = Int(filteredCodMostand.first ?? 0)
                print(filteredCodMostand)
                print(self.idsfather)
            }
            
       
          }
    func configureDropDownLevel() {
       
        let levelList = self.saf_drasi1
            // Set up the Dropdown
            levelFilter.optionArray = levelList

            levelFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.saf_drasi
                    .filter { $0.n_cls == selectedItem }
                    .compactMap { $0.id_cls }
                self.idCls = Int(filteredCodMostand.first ?? 0)
                // Now you can use the filteredCodMostand array as needed.
                print(filteredCodMostand)
                print(self.idCls)
            }
        }
    func configureDropDownMada() {
        
        let madaList = self.mada1
            // Set up the Dropdown
            madaFilter.optionArray = madaList

        madaFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.mada
                    .filter { $0.n_sub == selectedItem }
                    .compactMap { $0.id_sub }
                self.idstub = Int(filteredCodMostand.first ?? 0)
                // Now you can use the filteredCodMostand array as needed.
                print(filteredCodMostand)
                print(self.idstub)
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
   
    
    func searchForStudent(_searchText: String) {
        establishDBConnection()

        guard let client = self.client else {
            print("Client not available")
            return
        }
        stud_name.removeAll()
        let query2 = "SELECT TOP 10 n_stud , id_stud FROM name_stud WHERE n_stud LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(StudentName.self, from: jsonData)
                        self.stud_name.append(instance)
                        self.stud_name1.append(instance.n_stud ?? "" )

                        print("Student name: \(self.stud_name)")
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
       
    }
    
    func searchForLevel(_searchText: String) {
        establishDBConnection()

        guard let client = self.client else {
            print("Client not available")
            return
        }
        saf_drasi.removeAll()
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
                        self.saf_drasi.append(instance)
                        self.saf_drasi1.append(instance.n_cls ?? "" )
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
       
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
                        self.mada1.append(instance.n_sub ?? "" )

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
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = stud_name.filter { ($0.n_stud?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = stud_name.firstIndex { $0.n_stud == firstMatch.n_stud } ?? 0
                currentIndex = index
                if let studentName = firstMatch.n_stud {
                }
            }
        }
        configureDropDownStudent()
        searchForStudent(_searchText: searchText)
    }
    
    @objc func saf_drasidDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = saf_drasi.filter { ($0.n_cls?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = saf_drasi.firstIndex { $0.n_cls == firstMatch.n_cls } ?? 0
                currentIndex = index
                //                if let studentName = firstMatch.n_cls {
                //                }
            }
        }
        configureDropDownLevel()

        searchForLevel(_searchText: searchText)
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
        configureDropDownMada()
        searchForMada(_searchText: searchText)
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
        userFilter.optionArray = usersList1

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
        configureDropDownFather()
        searchForFather(_searchText: searchText)
    }
    
    
    
    
    
    @objc func closePicker(){
        view.endEditing(true)
        if !stud_name.isEmpty && currentIndex < stud_name.count {
            let selectedStud = stud_name[currentIndex]
            studentNameFilter.text = selectedStud.n_stud
        }
        
        
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
                    y = "id_f_stud"
                }
                
                var x = ""
                x = "SELECT n_cls, n_stud, id_stud, id_f_stud, tel_m, gen, n_sub, id_sub, SUM(q_in) AS q_in, SUM(q_out) AS q_out, SUM(r) AS r, ROW_NUMBER() OVER(ORDER BY " + y + "n_cls) AS nn FROM bal_hour_f WHERE dates Between '" + start_date + "' AND '" + end_date + "'"
                
                if idStud != 0 && studentNameFilter.text != "" {
                    x = x + " AND id_stud = '" + String(idStud) + "'"
                    
                }
                
                if  idsfather != 0 && fatherFilter.text != "" {
                    x = x + " AND id_f_stud = '" + String(idsfather) + "'"
                    
                }
                
                
                if idCls != 0 &&  levelFilter.text != "" {
                    x = x + " AND id_cls = '" + String(idCls) + "'"
                    
                }
                
                
                if idstub  != 0 && madaFilter.text != "" {
                    x = x + " AND id_sub = '" + String(idstub) + "'"
                    
                }
                
                if userFilter.text != "" {
                    x = x + " AND users = '" + (userFilter.text ?? "") + "'"
                    
                }
                
                x = x + " GROUP BY n_cls, n_stud, id_stud, id_f_stud, tel_m, gen, n_sub, id_sub HAVING (SUM(r) <> 0) ORDER BY " + y + "n_cls ASC"
                
                query = x
                
            }
            
            
            
            
            
            
            
            if let navigationController = self.navigationController {
                if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? BalHourFViewController {
                    previousViewController.query = query
                    print("on pop")
                    print(query)
                    navigationController.popViewController(animated: true)
                }
            }
        }
        
    }
}


