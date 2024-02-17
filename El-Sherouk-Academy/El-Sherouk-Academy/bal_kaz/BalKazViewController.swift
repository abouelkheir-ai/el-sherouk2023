//
//  BalKazViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 30/10/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class BalKazViewController: UIViewController , UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate  {
    var client = SQLClient.sharedInstance()
    var list_balKaz: [BalKaz] = []
    var listPermission: [ScreenPermesiion] = []

    
    var kazList: [KazName] = []
    var kazList1: [String] = []
    var termBegin = ""
    var termEnd = ""
    var kaz_id = 0;
    var open_mang = 0
    var _r = 0.0;
    var loginUser = "admain"
    var currentIndex = 0
    let pickerKazName = UIPickerView()
    var queryShow = ""
    var accessGrant = 0
    var query = ""
    var queryCheck = ""
    var queryKaz = ""
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var showAllButton: UIButton!
    @IBOutlet weak var kazNameFilter: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kazNameFilter.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "تسجيل خروج", style: .plain, target: self, action: #selector(logOut))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate=self
        tableView.dataSource=self
            
        
 
        searchForKaz(_searchText: "")
        kazNameFilter.backgroundColor = .white
        kazNameFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

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
//                kazNameFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                kazNameFilter.textColor = isDarkMode ? .white : .black
//                
//               
//               
//               
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
//            }
//        }
    
    
    
    func configureDropDownSafe() {
        let fatherNameList = self.kazList1
            kazNameFilter.optionArray = fatherNameList

        kazNameFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.kazList
                    .filter { $0.n_acc == selectedItem }
                    .compactMap { $0.id_acc }
                self.kaz_id = Int(filteredCodMostand.first ?? 0)
                print(filteredCodMostand)
                print(self.kaz_id)
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
    
    func searchForKaz(_searchText: String) {
        establishDBConnection()
        
        if(accessGrant == 0){
            queryKaz  = "SELECT TOP 10 n_acc , id_acc FROM name_kaz WHERE  mang = 0 and n_acc  LIKE '%\(_searchText)%'"
            
        }else{
            queryKaz = "SELECT TOP 10 n_acc , id_acc FROM name_kaz WHERE n_acc  LIKE '%\(_searchText)%'"
        }

        guard let client = self.client else {
            print("Client not available")
            return
        }
        kazList.removeAll()
        
        client.execute(queryKaz) { results in
            guard let result = results else {
                print("Error retrieving data")
                return
            }
            
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
                        let instance = try JSONDecoder().decode(KazName.self, from: jsonData)
                        self.kazList.append(instance)
                        self.kazList1.append(instance.n_acc ?? "" )
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
               let filteredkaz = kazList.filter { $0.n_acc!.lowercased().contains(searchText.lowercased()) }
               if let firstMatch = filteredkaz.first {
                   let index = kazList.firstIndex { $0.id_acc == firstMatch.id_acc } ?? 0
                   currentIndex = index
                   kaz_id = firstMatch.id_acc ?? 0

               }
           }
        searchForKaz(_searchText: searchText)
        configureDropDownSafe()
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
        return list_balKaz.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bal_kaz_cell") as? BalKazTableViewCell else { return UITableViewCell() }
        print(indexPath)
        
        cell.setupCell(codAcc: list_balKaz[indexPath.row].cod_acc ?? "", nAcc: list_balKaz[indexPath.row].n_acc ?? "", r: list_balKaz[indexPath.row].r ?? 0)
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

            self.list_balKaz.removeAll()
            kaz_id = 0
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
                            let instance = try JSONDecoder().decode(BalKaz.self, from: jsonData)
                            self.list_balKaz.append(instance)
                            
                            self._r += instance.r ?? 0
                          
                           

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
    func connectCheckAcess()  {
        print(queryCheck)
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

            client.execute(self.queryCheck) { results in
                guard let result = results else {
                    print("error")
                    return
                }

                print(self.queryCheck)
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
                            let instance = try JSONDecoder().decode(Permissions.self, from: jsonData)
                            self.accessGrant = (instance.s ?? 0)
                                                    print("done")
                            if(self.accessGrant == 0){
                                self.showSnackBar(message: "no permission")
                            }else{
                                self.open_mang = 1
                            }
                            self.tableView.reloadData()
                            client.disconnect()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
       
        }

     func showAlertWithDetails(r: Double) {
         let formattedNumber = String(format: "%.2f", r)

        let message = """
          رصيد فعلي:\(formattedNumber)
        """
        let alert = UIAlertController(title: "الاجمالي", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func show_total(_ sender: Any) {
        print(_r)
        showAlertWithDetails(r: _r)
    }
    
    @IBAction func checkAcess(_ sender: Any) {
        
         queryCheck = "select s from slahiat where n_perm = '" + loginUser + "' and no_forms = 201 "
        
        connectCheckAcess()
        
        

    }
    
   
  
    @IBAction func search(_ sender: Any) {
        print("search")
        
        _r = 0.0;
       
    var  x = "SELECT * FROM bal_kaz WHERE"

        if kaz_id != 0 && kazNameFilter.text != ""{
            x = x + " AND id_acc = '" + String(kaz_id) + "'"

        }

        if open_mang == 0 {
            x = x + " AND mang = '0'"

        }
        x = x + " ORDER BY r DESC"
        x = x.replacingOccurrences(of: " WHERE AND ", with: " WHERE ")
        x = x.replacingOccurrences(of: " WHERE ORDER ", with: " ORDER ")
       query = x


        connect()
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if(self.list_balKaz.isEmpty){
                self.showSnackBar(message: "no data")
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
        return kazList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return kazList[row].n_acc
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentIndex = row
        kaz_id = kazList[row].id_acc ?? 0
        kazNameFilter.text = kazList[row].n_acc
    }
       
   

}


