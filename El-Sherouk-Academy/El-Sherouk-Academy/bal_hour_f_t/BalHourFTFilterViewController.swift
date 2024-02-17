//
//  BalHourFTViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 29/10/2023.
//

import UIKit
import iOSDropDown
class BalHourFTFilterViewController: UIViewController  ,UITextFieldDelegate  {
    var client: SQLClient?
    var saf_drasi: [SafDrasi] = []
    var saf_drasi1: [String] = []
    var usersList: [Users] = []
    var usersList1: [String] = []
    var fatherList: [Father] = []
    var fatherList1: [String] = []
    var idCls = 0;
    var idsfather = 0;

    var currentIndex = 0
    var query = ""
    var switchOn = false
    var switchOn2 = false

   
    
    
    
    
    @IBOutlet weak var levelFilter: DropDown!
    
    
    @IBOutlet weak var fatherFilter: DropDown!
    @IBOutlet weak var userFilter: DropDown!
    
    @IBOutlet weak var rrFilter: DropDown!
    @IBOutlet weak var switchCheck: UISwitch!
    
    @IBOutlet weak var switchCheck2: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        levelFilter.addTarget(self, action: #selector(saf_drasidDidChange), for: .editingChanged)
        userFilter.addTarget(self, action: #selector(userdDidChange), for: .editingChanged)
        fatherFilter.addTarget(self, action: #selector(fatherdDidChange), for: .editingChanged)
        
        
       
       
        
       searchForUser(_searchText: "")
        searchForLevel(_searchText: "")
      searchForFather(_searchText: "")

        
        userFilter.backgroundColor = .white
        levelFilter.backgroundColor = .white
        fatherFilter.backgroundColor = .white
        userFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        levelFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        fatherFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

       
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
//              
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
//    
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
    
    func configureDropDownUser() {
     
        let userList = self.usersList1
            // Set up the Dropdown
            userFilter.optionArray = userList

            userFilter.didSelect { (selectedItem, index, id) in
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
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        client?.disconnect()
        print("disconnect")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   
    
    
    @IBAction func switchChange(_ sender: UISwitch) {
        if sender.isOn {
            switchOn = true
        } else {
            switchOn = false
        }
        print(switchOn)  }
    
    
    @IBAction func switch2Change(_ sender: UISwitch) {
        if sender.isOn {
            switchOn2 = true
        } else {
            switchOn2 = false
        }
        print(switchOn2)  }
    
    
    @IBAction func passQuery(_ sender: Any) {
        var y = ""
        
        if (switchOn) {
            y = "id_f_stud"
        }else{
            y = ""
        }

        var x = ""
        
        if (switchOn2) {
            x = "SELECT *, ROW_NUMBER() OVER(ORDER BY " + y + "n_cls, n_stud) AS nn FROM bal_hour_f_t WHERE"
        }else{
            x = "SELECT *, ROW_NUMBER() OVER(ORDER BY " + y + "n_cls, n_stud) AS nn FROM bal_hour_f_sub WHERE"
        }


        if userFilter.text != "" {
            x = x + " AND users = '" + (userFilter.text ?? "") + "'"

        }

        if idCls != 0 && levelFilter.text != "" {
            x = x + " AND id_cls = '" + String(idCls) + "'"

        }

        if idsfather != 0  && fatherFilter.text != "" {
            x = x + " AND id_f_stud = '" + String(idsfather) + "'"

        }

        if rrFilter.text != "" {
            x = x + " AND r <= '" + (rrFilter.text ?? "") + "'"

        }
        x = x + " ORDER BY " + y + "n_cls, n_stud ASC"
        

        x = x.replacingOccurrences(of: " WHERE AND ", with: " WHERE ")
        x = x.replacingOccurrences(of: " WHERE ORDER ", with: " ORDER ")

        query = x


                
                
            
       
        

        if let navigationController = self.navigationController {
            if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? BalHourFTViewController {
                previousViewController.query = query
                print("on pop")
                print(query)
                navigationController.popViewController(animated: true)
            }
        }
    }
    
    
}


