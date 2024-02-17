//
//  YAttAbsGroupTTViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 02/11/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class YAttAbsGroupTTViewController: UIViewController  ,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    var listPermission: [ScreenPermesiion] = []

    
  

    
  
    var years: [String] = []

    
    
    var client = SQLClient.sharedInstance()
    var list_YattGroup: [YattGorupTT] = []
    var list_nGroup: [NGroup] = []
    var list_nGroup1: [String] = []

    var termBegin = ""
    var termEnd = ""
    
    var _tAtt = 0;
    var _tAbs = 0;
    var _tNo = 0;
    var currentIndex = 0
    var query = ""
    var idGroup = 0
    let dateFormatter = DateFormatter()

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var groupPickFilter: DropDown!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupPickFilter.addTarget(self, action: #selector(groupDidChange), for: .editingChanged)

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "تسجيل خروج", style: .plain, target: self, action: #selector(logOut))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate=self
        tableView.dataSource=self
        
         
           
         
          
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "uk")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        print("Current date and time is: \(dateString)")
        start_date = dateString
        print("dod")
        print(termBegin)
        print(termEnd)
        searchForNGroup(_searchText: "")
            groupPickFilter.backgroundColor = .white
        groupPickFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

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
//                groupPickFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                groupPickFilter.textColor = isDarkMode ? .white : .black
//                
//              
//                
//               
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
//            }
//        }
    
    func configureDropDownFather() {
            
            let groupList = self.list_nGroup1
                // Set up the Dropdown
                groupPickFilter.optionArray = groupList

        groupPickFilter.didSelect { (selectedItem, index, id) in
                    print("Selected item: \(selectedItem) at index \(index)")
                    let filteredCodMostand = self.list_nGroup
                        .filter { $0.n_group == selectedItem }
                        .compactMap { $0.id_group }
                    self.idGroup = Int(filteredCodMostand.first ?? 0)
                    // Now you can use the filteredCodMostand array as needed.
                    print(filteredCodMostand)
                    print(self.idGroup)
                }
            }
    
    @objc func groupDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = list_nGroup.filter { ($0.n_group?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = list_nGroup.firstIndex { $0.n_group == firstMatch.n_group } ?? 0
                currentIndex = index
                
            }
        }
        searchForNGroup(_searchText: searchText)
        configureDropDownFather()
    }
    
    
    
    
    @objc func closePicker(){
        view.endEditing(true)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func logOut() {
        UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        client?.disconnect()
        print("disconnect")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(list_YattGroup.count)
        return list_YattGroup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "y_att_abs_cell") as? YattabsGroupTTTableViewCell else { return UITableViewCell() }
        print(indexPath)
        
        cell.setupCell(n_stud: list_YattGroup[indexPath.row].n_stud ?? "", att: list_YattGroup[indexPath.row].att ?? 0, abs: list_YattGroup[indexPath.row].abs ?? 0, noattabs: list_YattGroup[indexPath.row].no_att_abs ?? 0)
        return cell
    }
    func connect()  {
        print(query)
        print("connect")
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
        
        self.list_YattGroup.removeAll()
        client.execute(self.query) { results in
            guard let result = results else {
                print("error")
                return
            }
            
            print(self.query)
            print("true2")
            for table in result {
                guard let table = table as? NSArray else {
                    print("here2")
                    continue
                }
                //                    print(table)
                if table.count == 0 {
                    client.disconnect()
                }
                for row in table {
                    guard let row = row as? [AnyHashable : Any] else {
                        print("here3")
                        continue
                    }
                    
                    print(row)
                    //                    print(row)
                    // serialize json to text
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: row)
                        let instance = try JSONDecoder().decode(YattGorupTT.self, from: jsonData)
                        self.list_YattGroup.append(instance)
                        self._tAtt += instance.att ?? 0
                        self._tAbs += instance.abs ?? 0
                        self._tNo += instance.no_att_abs ?? 0
                        
                        
                        
                        print("done")
                        print(instance)
                        self.tableView.reloadData()
                        client.disconnect()
                        
                    } catch {
                        print(error)
                    }
                }
            }
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
    
    func searchForNGroup(_searchText: String) {
        establishDBConnection()
        guard let client = self.client else {
            print("Client not available")
            return
        }
        list_nGroup.removeAll()
        let query2 = "SELECT TOP 10 n_group ,id_group FROM name_group WHERE n_group LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(NGroup.self, from: jsonData)
                        self.list_nGroup.append(instance)
                        self.list_nGroup1.append(instance.n_group ?? "")
                        self.idGroup = instance.id_group ?? 0
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        
    }
       
  
    
    func showAlertWithDetails(tAtt: Int,tAbs: Int,tNo: Int) {
        let  message = """
        حصص الحضور: \(tAtt)
        حصص الغياب: \(tAbs)
        غياب بدون اذن: \(tNo)
        
        """
        let alert = UIAlertController(title: "الاجمالي", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func show_total(_ sender: Any) {
        showAlertWithDetails(tAtt: _tAtt, tAbs: _tAbs, tNo: _tNo)
    }
    
    
    
    @IBAction func search(_ sender: Any) {
        print("search")
        
        _tAbs = 0;
        _tAtt = 0;
        _tNo = 0;
        guard let startDate = dateFormatter.date(from: start_date),
              let termBeginDate = dateFormatter.date(from: termBegin),
              let termEndDate = dateFormatter.date(from: termEnd) else {
            print("start_date")
            print(start_date)
            print("termBegin")
            print(termBegin)
            print("termEnd")
            print(termEnd)

            print("Failed to convert dates")
            return
        }
        
        if (startDate < termBeginDate) || (startDate > termEndDate) {
            print("button tapped5")
            showSnackBar(message: "out of range")
        } else {
            if groupPickFilter.text == "" || idGroup == 0 {
                showSnackBar(message: "من فضلك اختار المجموعه")
            }else{
                query = "SELECT *, ROW_NUMBER() OVER(ORDER BY n_stud) AS nn FROM y_att_abs_group_tt WHERE dates = '" + start_date + "' AND id_group = '" + String(idGroup) + "' ORDER BY n_stud ASC"
            }
            
          
            
            }
       
        
        
        connect()
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if(self.list_YattGroup.isEmpty){
                self.showSnackBar(message: "no data")
            }
        }
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
    func showSnackBar(message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Snack Bar", body: message)
        view.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        SwiftMessages.show(config: config, view: view)
    }
  
    
    

    
   
    
    

}
