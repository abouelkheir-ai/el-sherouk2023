//
//  TiradTViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 06/11/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class TiradTViewController: UIViewController , UITableViewDelegate, UITableViewDataSource  ,UITextFieldDelegate  {
    
    var client = SQLClient.sharedInstance()
    var list_tiradt: [TiradT] = []
    var listPermission: [ScreenPermesiion] = []

    var termBegin = ""
    var termEnd = ""
    
    var usersList: [Users] = []
    var usersList1: [String] = []

    var _cash = 0.0;
    var _bank = 0.0;
    var _t = 0.0;
    var currentIndex = 0
    let pickerUserName = UIPickerView()
    var queryShow = ""
    var accessGrant = 0
    var query = ""
    var queryCheck = ""
    var queryKaz = ""
    let dateFormatter = DateFormatter()

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var showAllButton: UIButton!
    @IBOutlet weak var userNameFilter: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameFilter.addTarget(self, action: #selector(userFieldDidChange), for: .editingChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "تسجيل خروج", style: .plain, target: self, action: #selector(logOut))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate=self
        tableView.dataSource=self
        
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
        searchForUser(_searchText: "")
        userNameFilter.backgroundColor = .white
        userNameFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

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
//                userNameFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                userNameFilter.textColor = isDarkMode ? .white : .black
//                
//               
//                
//           
//            }
        }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            updateUIForCurrentTraitCollection()
        }
    
    
    
    func configureDropDownUser() {
     
        let userList = self.usersList1
            // Set up the Dropdown
        userNameFilter.optionArray = userList

        userNameFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
            }
        }
    
    func showSnackBar(message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Snack Bar", body: message)
        view.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        SwiftMessages.show(config: config, view: view)
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
        DispatchQueue.main.async {
            self.pickerUserName.reloadAllComponents()
        }
    }
    
    @objc func userFieldDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = usersList.filter { ($0.users?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = usersList.firstIndex { $0.users == firstMatch.users } ?? 0
                currentIndex = index
                pickerUserName.selectRow(index, inComponent: 0, animated: true)
                
            }
        }
        searchForUser(_searchText: searchText)
        configureDropDownUser()
    }
    
    @objc func logOut() {
        UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func closePicker(){
        view.endEditing(true)
       
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        client?.disconnect()
        print("disconnect")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list_tiradt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "t_irad_t_cell") as? TiradtTableViewCell else { return UITableViewCell() }
        print(indexPath)
        

        cell.setupCell(dates: list_tiradt[indexPath.row].dates ?? "", cash: list_tiradt[indexPath.row].cash ?? 0, bank: list_tiradt[indexPath.row].bank ?? 0, t: list_tiradt[indexPath.row].t ?? 0)
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

            self.list_tiradt.removeAll()
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
                            let instance = try JSONDecoder().decode(TiradT.self, from: jsonData)
                            self.list_tiradt.append(instance)
                            
                            self._cash += instance.cash ?? 0
                            self._bank += instance.bank ?? 0
                            self._t += instance.t ?? 0

                           

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
   

     func showAlertWithDetails(cash: Double,bank: Double,t: Double) {
         let formattedNumber = String(format: "%.2f", cash)
         let formattedNumber2 = String(format: "%.2f", bank)
         let formattedNumber3 = String(format: "%.2f", t)

        let message = """
                 نقدي:\(formattedNumber)
                 بنك:\(formattedNumber2)
                المبلغ:\(formattedNumber3)
        """
        let alert = UIAlertController(title: "الاجمالي", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func show_total(_ sender: Any) {
        showAlertWithDetails(cash: _cash, bank: _bank, t: _t)
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
    
    @IBAction func search(_ sender: Any) {
        print("search")
        
        
        _cash = 0.0
        _bank = 0.0
        _t = 0.0
        
        if let startDate = dateFormatter.date(from: start_date),
           let endDate = dateFormatter.date(from: end_date),
           let termBeginDate = dateFormatter.date(from: termBegin),
           let termEndDate = dateFormatter.date(from: termEnd) {
            if (startDate < termBeginDate) || (startDate > termEndDate) {
                showSnackBar(message: "out of range")
            } else if (endDate < termBeginDate) || (endDate > termEndDate) {
                showSnackBar(message: "out of range")
            } else {
                
                var x  = ""
                x = "SELECT dates, SUM(cash) AS cash, SUM(bank) AS bank, SUM(t) AS t, ROW_NUMBER() OVER(ORDER BY dates) AS nn FROM t_irad WHERE dates Between '" + start_date + "' AND '" + end_date + "'"

                if userNameFilter.text != "" {
                    x = x + " AND users = '" + (userNameFilter.text ?? "")  + "'"

                }

                x = x + " GROUP BY dates ORDER BY dates ASC"

               query = x

                
                
            }
            
            
            connect()
            tableView.reloadData()
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 600
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                
                if(self.list_tiradt.isEmpty){
                    self.showSnackBar(message: "message")
                }
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usersList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return usersList[row].users
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentIndex = row
        userNameFilter.text = usersList[row].users
    }
       
   

}


