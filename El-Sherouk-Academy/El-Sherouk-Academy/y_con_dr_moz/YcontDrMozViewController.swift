//
//  YcontDrMozViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 01/11/2023.
//

import UIKit
import SwiftMessages
import iOSDropDown
class YcontDrMozViewController: UIViewController ,UITextFieldDelegate , UITableViewDelegate, UITableViewDataSource {
    var client = SQLClient.sharedInstance()
    var employeeList: [Employee] = []
    var employeeList1: [String] = []
    var listPermission: [ScreenPermesiion] = []
    var termBegin = ""
    var termEnd = ""
    var idEmployee = "";
    var currentIndex = 0
    var query = ""
    var list_ycontdrmoz: [YcontDrMoz] = []
    var _q = 0;
    @IBOutlet weak var employeeFilter: DropDown!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        employeeFilter.addTarget(self, action: #selector(employeedDidChange), for: .editingChanged)
          
        
            tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate=self
        tableView.dataSource=self
        searchForEmployee(_searchText: "")
        employeeFilter.backgroundColor = .white
        employeeFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

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
//                employeeFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                employeeFilter.textColor = isDarkMode ? .white : .black
//                
//               
//              
//                
//              
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
//            }
//        }
    func configureDropDownEmployee() {
            
            let employeeList = self.employeeList1
                // Set up the Dropdown
                employeeFilter.optionArray = employeeList

        employeeFilter.didSelect { (selectedItem, index, id) in
                    print("Selected item: \(selectedItem) at index \(index)")
                    let filteredCodMostand = self.employeeList
                        .filter { $0.n_moz == selectedItem }
                        .compactMap { $0.id_moz }
                    self.idEmployee = filteredCodMostand.first ?? ""
                    // Now you can use the filteredCodMostand array as needed.
                    print(filteredCodMostand)
                    print(self.idEmployee)
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
    func searchForEmployee(_searchText: String) {
        establishDBConnection()
        
        guard let client = self.client else {
            print("Client not available")
            return
        }
        employeeList.removeAll()
        let query2 = "SELECT TOP 10 n_moz , id_moz FROM name_moz_rep WHERE n_moz LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(Employee.self, from: jsonData)
                        self.employeeList.append(instance)
                        self.employeeList1.append(instance.n_moz ?? "" )
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
       
    }
    @objc func employeedDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = employeeList.filter { ($0.n_moz?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = employeeList.firstIndex { $0.n_moz == firstMatch.n_moz } ?? 0
                currentIndex = index
                
            }
        }
        searchForEmployee(_searchText: searchText)
        configureDropDownEmployee()
    }
    @objc func closePicker(){
        view.endEditing(true)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   
    
   
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        client?.disconnect()
        print("disconnect")
    }
    func connect(_query : String)  {
        establishDBConnection()
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

            self.list_ycontdrmoz.removeAll()
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
                            let instance = try JSONDecoder().decode(YcontDrMoz.self, from: jsonData)
                            self.list_ycontdrmoz.append(instance)

                          
                           

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
    
 
    func showAlertWithDetails(q: Int) {
        let  message = """
         عدد العقود:\(q)

        """
        let alert = UIAlertController(title: "الاجمالي", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func show_total(_ sender: Any) {
        showAlertWithDetails(q: _q)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(list_ycontdrmoz.count)
        _q = list_ycontdrmoz.count
        return list_ycontdrmoz.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "y_cont_dr_cell") as? YcontDrMozTableViewCell else { return UITableViewCell() }
        print(indexPath)

        cell.setupCell(dates: list_ycontdrmoz[indexPath.row].d_wrk ?? "", mostand: list_ycontdrmoz[indexPath.row].mostand ?? "", wazefa: list_ycontdrmoz[indexPath.row].n_waz ?? "", nohdwam: list_ycontdrmoz[indexPath.row].n_wrk_time ?? "", sal: list_ycontdrmoz[indexPath.row].sal ?? 0, homeSal: list_ycontdrmoz[indexPath.row].hous_alw ?? 0, calSal: list_ycontdrmoz[indexPath.row].call_alw ?? 0, dClr: list_ycontdrmoz[indexPath.row].d_clr ?? "", nClr: list_ycontdrmoz[indexPath.row].n_clr ?? 0)
        return cell
    }
    
    @IBAction func search(_ sender: Any) {
        print("search")
        
         _q = 0;
        if employeeFilter.text == "" || idEmployee == "" {
            
        }
        else{
            query = "SELECT * FROM y_cont_clr_moz WHERE id_moz = '" + idEmployee + "' ORDER BY cerial ASC"
        }
        
        connect(_query: query)
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if(self.list_ycontdrmoz.isEmpty){
                self.showSnackBar(message: "no data")
            }
        }
    }
    
}
