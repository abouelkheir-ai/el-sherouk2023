//
//  YresignFilterViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 31/10/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class YresignFilterViewController: UIViewController  ,UITextFieldDelegate  {
    var client: SQLClient?
    var wazList: [Wazefa] = []
    var wazList1: [String] = []

    
    
    
    var id_waz = 0;
   
    
    var termBegin = ""
    var termEnd = ""
    var currentIndex = 0
    var query = ""
    var switchOn = false
    
    
    let pickerWaz = UIPickerView()
    
    
    let dateFormatter = DateFormatter()
    
    
    
    
    @IBOutlet weak var wazFilter: DropDown!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wazFilter.addTarget(self, action: #selector(wazdDidChange), for: .editingChanged)
        
        
            
          
      
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
        searchForWaz(_searchText: "")
        
        wazFilter.backgroundColor = .white
        wazFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

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
//                wazFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                wazFilter.textColor = isDarkMode ? .white : .black
//                
//               
//              
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
//            }
//        }
//    
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
    
    
    func configureDropDownWaz() {
        let wazefaList = self.wazList1
            wazFilter.optionArray = wazefaList

        wazFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.wazList
                    .filter { $0.n_waz == selectedItem }
                    .compactMap { $0.id_waz }
                self.id_waz = Int(filteredCodMostand.first ?? 0)
                print(filteredCodMostand)
                print(self.id_waz)
            }
            
       
          }
    
    func searchForWaz(_searchText: String) {
        establishDBConnection()
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        wazList.removeAll()
        let query2 = "SELECT TOP 10 n_waz, id_waz FROM name_waz WHERE n_waz LIKE '%\(_searchText)%'"
        
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
                        self.wazList.append(instance)
                        self.wazList1.append(instance.n_waz ?? "")
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
       
    }
    
    
    
    
    @objc func wazdDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = wazList.filter { ($0.n_waz?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = wazList.firstIndex { $0.n_waz == firstMatch.n_waz } ?? 0
                currentIndex = index
                pickerWaz.selectRow(index, inComponent: 0, animated: true)
                //                if let studentName = firstMatch.n_cls {
                //                }
            }
        }
        searchForWaz(_searchText: searchText)
        configureDropDownWaz()
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
                x = "SELECT * FROM y_resign_moz WHERE dates BETWEEN '" + start_date + "' AND '" + end_date + "'"

                if id_waz != 0 && wazFilter.text != "" {
                    x = x + " AND id_waz = '" + String(id_waz) + "'"

                }

                x = x + " ORDER BY cerial ASC"

                query = x

               
                
            }
            
            
            if let navigationController = self.navigationController {
                if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? YResignMozViewController {
                    previousViewController.query = query
                    print("on pop")
                    print(query)
                    navigationController.popViewController(animated: true)
                }
            }
        }
    }
    
}


