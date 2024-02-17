//
//  StHourFFilterViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 07/11/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class StHourFFilterViewController: UIViewController  ,UITextFieldDelegate  {
    var client: SQLClient?
    var studentName: [StudentName] = []
    var studentName1: [String] = []
    var mada: [Mada] = []
    var mada1: [String] = []

    var idStudent = 0
    var idMada = 0;

   
    var termBegin = ""
    var termEnd = ""
    var currentIndex = 0
    var query = ""
    var switchOn = false


    let dateFormatter = DateFormatter()

    
    
    
    
     @IBOutlet weak var studentNameFilter: DropDown!
    @IBOutlet weak var madaFilter: DropDown!

  
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
      
        studentNameFilter.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        madaFilter.addTarget(self, action: #selector(madadDidChange), for: .editingChanged)

               
         
            
          
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "uk")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        print("Current date and time is: \(dateString)")
        start_date = dateString
        end_date = dateString
        searchForMada(_searchText: "")
        searchForStudent(_searchText: "")
        madaFilter.backgroundColor = .white
        studentNameFilter.backgroundColor = .white
        studentNameFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        madaFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

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
//                studentNameFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                studentNameFilter.textColor = isDarkMode ? .white : .black
//                
//                madaFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                madaFilter.textColor = isDarkMode ? .white : .black
//               
//           
//            }
        }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            updateUIForCurrentTraitCollection()
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
    
    func configureDropDownStudent() {
            
            let studentList = self.studentName1
                // Set up the Dropdown
                studentNameFilter.optionArray = studentList

        studentNameFilter.didSelect { (selectedItem, index, id) in
                    print("Selected item: \(selectedItem) at index \(index)")
                    let filteredCodMostand = self.studentName
                        .filter { $0.n_stud == selectedItem }
                        .compactMap { $0.id_stud }
                    self.idStudent = Int(filteredCodMostand.first ?? 0)
                    // Now you can use the filteredCodMostand array as needed.
                    print(filteredCodMostand)
                    print(self.idStudent)
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
                    self.idMada = Int(filteredCodMostand.first ?? 0)
                    // Now you can use the filteredCodMostand array as needed.
                    print(filteredCodMostand)
                    print(self.idMada)
                }
            }
    
    func searchForStudent(_searchText: String) {
        establishDBConnection()

        guard let client = self.client else {
            print("Client not available")
            return
        }
        studentName.removeAll()
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
                        self.studentName.append(instance)
                        self.studentName1.append(instance.n_stud ?? "")
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
   
      @objc func textFieldDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = studentName.filter { ($0.n_stud?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = studentName.firstIndex { $0.n_stud == firstMatch.n_stud } ?? 0
                currentIndex = index
                if let studentName = firstMatch.n_stud {
                }
            }
        }
        searchForStudent(_searchText: searchText)
          configureDropDownStudent()
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

                
                if idStudent == 0 || studentNameFilter.text == "" {
                 

                }else{
                    x = "SELECT * FROM st_hour_f WHERE dates BETWEEN '" + start_date + "' AND '" + end_date + "' AND id_stud = '" + String(idStudent) + "'"
                }
               

                if idMada != 0 || madaFilter.text != "" {
                    x = x + " AND id_sub = '" + String(idMada) + "'"

                }

                x = x + " ORDER BY td00 ASC"

                query = x

            }
            
            
       
            
            
            if let navigationController = self.navigationController {
                if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? StHourFViewController {
                    previousViewController.query = query
                    print("on pop")
                    print(query)
                    navigationController.popViewController(animated: true)
                }
            }
        }
    }
    
}


