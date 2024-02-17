//
//  YcontMozViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 01/11/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class YcontMozFilterViewController: UIViewController ,UITextFieldDelegate  {
    var client: SQLClient?
    
    
    var workTimeList: [WorkTime] = []
    var workTimeList1: [String] = []
    var nohAkmaList = ["على إقامة الشركة","ليس على إقامة الشركة"]
    var wazefaList: [Wazefa] = []
    var wazefaList1: [String] = []
    var termBegin = ""
    var termEnd = ""
    
    
    var idWazefa = 0;
    var idworkTime = 0;

    
    var currentIndex = 0
    var query = ""
    

    
    let dateFormatter = DateFormatter()
    
    
    @IBOutlet weak var wazefaFilter: DropDown!
    @IBOutlet weak var workTimeFilter: DropDown!
    @IBOutlet weak var nohAkamaFilter: DropDown!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wazefaFilter.addTarget(self, action: #selector(wazefadDidChange), for: .editingChanged)
        workTimeFilter.addTarget(self, action: #selector(worktimedDidChange), for: .editingChanged)
        
        
              
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
        
        searchForWazefa(_searchText: "")
        searchForWorkTime(_searchText: "")
        nohAkamaFilter.optionArray = ["على إقامة الشركة","ليس على إقامة الشركة"]
        nohAkamaFilter.didSelect { (selectedText , index ,id) in
            self.nohAkamaFilter.text = "Selected String: \(selectedText) \n index: \(index)"
        }
        wazefaFilter.backgroundColor = .white
        workTimeFilter.backgroundColor = .white
        nohAkamaFilter.backgroundColor = .white
        wazefaFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        workTimeFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        nohAkamaFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

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
//                wazefaFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                wazefaFilter.textColor = isDarkMode ? .white : .black
//                
//               
//                nohAkamaFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                nohAkamaFilter.textColor = isDarkMode ? .white : .black
//                
//                workTimeFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                workTimeFilter.textColor = isDarkMode ? .white : .black
//               
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
//            }
//        }
//    
    func configureDropDownWazefa() {
            
            let wazefaList = self.wazefaList1
                // Set up the Dropdown
        wazefaFilter.optionArray = wazefaList

        wazefaFilter.didSelect { (selectedItem, index, id) in
                    print("Selected item: \(selectedItem) at index \(index)")
                    let filteredCodMostand = self.wazefaList
                        .filter { $0.n_waz == selectedItem }
                        .compactMap { $0.id_waz }
                    self.idWazefa = Int(filteredCodMostand.first ?? 0)
                    // Now you can use the filteredCodMostand array as needed.
                    print(filteredCodMostand)
                    print(self.idWazefa)
                }
            }
    func configureDropDownWorkTime() {
            
            let worktimeList = self.workTimeList1
                // Set up the Dropdown
                workTimeFilter.optionArray = worktimeList

        workTimeFilter.didSelect { (selectedItem, index, id) in
                    print("Selected item: \(selectedItem) at index \(index)")
                    let filteredCodMostand = self.workTimeList
                        .filter { $0.n_wrk_time == selectedItem }
                        .compactMap { $0.id_wrk_time }
                    self.idworkTime = Int(filteredCodMostand.first ?? 0)
                    // Now you can use the filteredCodMostand array as needed.
                    print(filteredCodMostand)
                    print(self.idworkTime)
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
    
    
    
    
    
    func searchForWazefa(_searchText: String) {
        establishDBConnection()
        guard let client = self.client else {
            print("Client not available")
            return
        }
        wazefaList.removeAll()
        let query2 = "SELECT TOP 10 n_waz ,id_waz FROM name_waz WHERE n_waz LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(Wazefa.self, from: jsonData)
                        self.wazefaList.append(instance)
                        self.wazefaList1.append(instance.n_waz ?? "")
                        self.idWazefa = instance.id_waz ?? 0
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        
    }
    func searchForWorkTime(_searchText: String) {
        establishDBConnection()
        guard let client = self.client else {
            print("Client not available")
            return
        }
        workTimeList.removeAll()
        let query2 = "SELECT TOP 10 n_wrk_time , id_wrk_time FROM name_wrk_time WHERE n_wrk_time LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(WorkTime.self, from: jsonData)
                        self.workTimeList.append(instance)
                        self.idworkTime = instance.id_wrk_time ?? 0
                        self.workTimeList1.append(instance.n_wrk_time ?? "")
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        
    }
    
    
    
    
    
    
    @objc func wazefadDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = wazefaList.filter { ($0.n_waz?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = wazefaList.firstIndex { $0.n_waz == firstMatch.n_waz } ?? 0
                currentIndex = index
                
            }
        }
        searchForWazefa(_searchText: searchText)
        configureDropDownWazefa()
    }
    @objc func worktimedDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = workTimeList.filter { ($0.n_wrk_time?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = workTimeList.firstIndex { $0.n_wrk_time == firstMatch.n_wrk_time } ?? 0
                currentIndex = index
                
            }
        }
        searchForWorkTime(_searchText: searchText)
        configureDropDownWorkTime()
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
           

            var x = ""
            x = "SELECT *, ROW_NUMBER() OVER(ORDER BY cerial) AS nn FROM y_cont_moz WHERE d_wrk BETWEEN '" + start_date + "' AND '" + end_date + "'"

            if idWazefa != 0 && wazefaFilter.text != "" {
                x = x + " AND id_waz = '" + String(idWazefa) + "'"

            }

            if idworkTime != 0 && workTimeFilter.text != "" {
                x = x + " AND id_wrk_time = '" + String(idworkTime) + "'"

            }

            if nohAkamaFilter.text != "" {
                x = x + " AND resid = '" + (nohAkamaFilter.text ?? "") + "'"

            }

            x = x + " ORDER BY cerial ASC"

            query = x

            
        }
        
        if let navigationController = self.navigationController {
            if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? YcontMozViewController {
                previousViewController.query = query
                print("on pop")
                print(query)
                navigationController.popViewController(animated: true)
            }
        }
    }
}
