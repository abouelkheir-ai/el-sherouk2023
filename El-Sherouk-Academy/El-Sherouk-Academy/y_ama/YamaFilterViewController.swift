//
//  YamaFilterViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 02/11/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown

class YamaFilterViewController: UIViewController  ,UITextFieldDelegate  {
    var client: SQLClient?
    var nohMostantList: [NohMostand] = []

    
    var termBegin = ""
    var termEnd = ""
    var currentIndex = 0
    var query = ""
    
    var idMostand = ""
    
    
    let dateFormatter = DateFormatter()
    
    
    
    
    @IBOutlet weak var nohMostandFilter: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nohMostandFilter.addTarget(self, action: #selector(nohMostanddDidChange), for: .editingChanged)
        
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
//        if #available(iOS 13.0, *) {
//                    overrideUserInterfaceStyle = .light // or .dark based on your preference
//                }
        nohMostandFilter.backgroundColor = .white
        nohMostandFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

        searchFornohMostand(_searchText: "")
    }
//    func updateUIForCurrentTraitCollection() {
//            if #available(iOS 13.0, *) {
//                let isDarkMode = traitCollection.userInterfaceStyle == .dark
//
//                // Customize UI elements for dark mode
//                // For example, update background colors, text colors, etc.
//                nohMostandFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                nohMostandFilter.textColor = isDarkMode ? .white : .black
//                
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
//            }
//        }
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//            super.traitCollectionDidChange(previousTraitCollection)
//            updateUIForCurrentTraitCollection()
//        }
    
    func configureDropDown() {
        let nohMostandList = self.nohMostantList.map { $0.noh_mostand ?? "" }
            // Set up the Dropdown
            nohMostandFilter.optionArray = nohMostandList

            nohMostandFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.nohMostantList
                    .filter { $0.noh_mostand == selectedItem }
                    .compactMap { $0.cod_mostand }
                self.idMostand = filteredCodMostand.first ?? ""
                // Now you can use the filteredCodMostand array as needed.
                print(filteredCodMostand)
                print(self.idMostand)
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
    
    
    
    
    func searchFornohMostand(_searchText: String) {
        establishDBConnection()
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        nohMostantList.removeAll()
        let query2 = "SELECT top 10 noh_mostand ,cod_mostand FROM noh_mostand_y WHERE noh_mostand LIKE '%\(_searchText)%'"
        
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
                    print(row)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: row)
                        let instance = try JSONDecoder().decode(NohMostand.self, from: jsonData)
                        self.nohMostantList.append(instance)
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        
    }
    
   
    
    
   
    @objc func nohMostanddDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = nohMostantList.filter { ($0.noh_mostand?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = nohMostantList.firstIndex { $0.noh_mostand == firstMatch.noh_mostand } ?? 0
                currentIndex = index
                //                if let studentName = firstMatch.n_cls {
                //                }
            }
        }
        configureDropDown()
        searchFornohMostand(_searchText: searchText)
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
                x = "SELECT * FROM y_ama WHERE dates BETWEEN '" + start_date + "' AND '" + end_date + "'"

                if nohMostandFilter.text != "" && idMostand != ""{
                    x = x + " AND cod_mostand = '" + String(idMostand) + "'"

                }

                x = x + " ORDER BY td00 ASC"

                query = x

            

                print (query)
                
            }
            
            
            
            if let navigationController = self.navigationController {
                if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? YamaViewController {
                    previousViewController.query = query
                    print("on pop")
                    print(query)
                    navigationController.popViewController(animated: true)
                }
            }
        }
        
    }
}


