//
//  YClrMozViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 02/11/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class YClrMozFilterViewController: UIViewController  ,UITextFieldDelegate  {
    var client: SQLClient?
    
    
    var wazefaList: [Wazefa] = []
    var wazefaList1: [String] = []
    var termBegin = ""
    var termEnd = ""
    
    
    var idWazefa = 0;

    
    var currentIndex = 0
    var query = ""
    
    let pickerWorkTime = UIPickerView()
    let pickerWazefa = UIPickerView()
    let pickerAkama = UIPickerView()
    let dateFormatter = DateFormatter()
    
    
    @IBOutlet weak var wazefaFilter: DropDown!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wazefaFilter.addTarget(self, action: #selector(wazefadDidChange), for: .editingChanged)
        
           
       
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "uk")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        print("Current date and time is: \(dateString)")
        start_date = dateString
        end_date = dateString
        
        searchForWazefa(_searchText: "")
        wazefaFilter.backgroundColor = .white
        wazefaFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

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
//              
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
//            }
//        }
    
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
            x = "SELECT * FROM y_clr_moz WHERE dates BETWEEN '" + start_date + "' AND '" + end_date + "'"

            if idWazefa != 0 && wazefaFilter.text != "" {
                x = x + " AND id_waz = '" + String(idWazefa) + "'"

            }

            x = x + " ORDER BY cerial ASC"

            query = x

    
            
        }
        
        if let navigationController = self.navigationController {
            if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? YclrMozViewController {
                previousViewController.query = query
                print("on pop")
                print(query)
                navigationController.popViewController(animated: true)
            }
        }
    }
}
