//
//  BalTargetKViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 30/10/2023.
//

import UIKit
import SwiftMessages
class BalTargetKViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , UIPickerViewDelegate, UIPickerViewDataSource {
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var years: [String] = []
    var termBegin = ""
    var termEnd = ""
    
    
    var client = SQLClient.sharedInstance()
    var list_baalTargetK: [BalTargetK] = []
    var listPermission: [ScreenPermesiion] = []

    
    var _k = 0.0;
    var _t = 0.0;
    var _r = 0.0;
    var currentIndex = 0
    var query = ""
    
    var n_m = ""
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var datePickFilter: UITextField!
    let pickerDate = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentYear = Calendar.current.component(.year, from: Date())
        years = (2020...currentYear).map { String($0) }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "تسجيل خروج", style: .plain, target: self, action: #selector(logOut))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate=self
        tableView.dataSource=self
        
        pickerDate.dataSource=self
        pickerDate.delegate=self
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePicker))
        toolBar.setItems([btnDone], animated: true)
        
        datePickFilter.inputView = pickerDate
        datePickFilter.inputAccessoryView = toolBar
        
        
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
        print(list_baalTargetK.count)
        return list_baalTargetK.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bal_target_k_cell") as? BalTargetKTableViewCell else { return UITableViewCell() }
        print(indexPath)
        
        //        cell.setupCell(users: list_baalTargetK[indexPath.row].n_moz ?? "", r: list_balKastU[indexPath.row].r ?? 0)
        cell.setupCell(users: list_baalTargetK[indexPath.row].users ?? "", nMoz: list_baalTargetK[indexPath.row].n_moz ?? "", k: list_baalTargetK[indexPath.row].k ?? 0, t: list_baalTargetK[indexPath.row].t ?? 0, r: list_baalTargetK[indexPath.row].r ?? 0)
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
        
        self.list_baalTargetK.removeAll()
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
                        let instance = try JSONDecoder().decode(BalTargetK.self, from: jsonData)
                        self.list_baalTargetK.append(instance)
                        self._k += instance.k ?? 0
                        self._t += instance.t ?? 0
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
    
    
    func showAlertWithDetails(k: Double,t: Double,r: Double) {
        let  message = """
        الخصم المستهدف: \(k)
        الخصم المنفذ: \(t)
        الرصيد: \(r)
        
        """
        let alert = UIAlertController(title: "الاجمالي", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func show_total(_ sender: Any) {
        showAlertWithDetails(k: _k, t: _t, r: _r)
    }
    
    
    
    @IBAction func search(_ sender: Any) {
        print("search")
        
        _t = 0.0;
        _k = 0.0;
        _r = 0.0;
        
        
        if datePickFilter.text == "" || n_m == "" {
            showSnackBar(message: "برجاء تسجيل شهر الخصم بشكل صحيح")
        }
        
        else{
            query = "SELECT *, ROW_NUMBER() OVER(ORDER BY users) AS nn FROM bal_target_k WHERE n_m = '" + String(n_m) + "' ORDER BY users ASC"
        }
        
        
        connect()
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if(self.list_baalTargetK.isEmpty){
                self.showSnackBar(message: "no data")
            }
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
    func getMonthNumber(monthName: String) -> Int? {
        let dateFormatter = DateFormatter()
        let month = dateFormatter.monthSymbols.firstIndex(of: monthName)
        return month.map { $0 + 1 }
    }
    func getFormattedDate(year: String, monthNumber: Int) -> String {
        let dateString = "\(year) \(String(format: "%02d", monthNumber)) 01" // Assuming day is 01
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return months.count
        } else {
            return years.count
        }
    }
    
    // MARK: - UIPickerViewDelegate methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return months[row]
        } else {
            return years[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerDate {
            let selectedMonthName = months[pickerDate.selectedRow(inComponent: 0)]
            let selectedYear = years[pickerDate.selectedRow(inComponent: 1)]

            if let monthNumber = getMonthNumber(monthName: selectedMonthName) {
                let formattedDate = getFormattedDate(year: selectedYear, monthNumber: monthNumber)
                print("Formatted Date: \(formattedDate)")
                n_m = formattedDate
            } else {
                print("Invalid month name")
            }

            datePickFilter.text = "\(selectedMonthName) \(selectedYear)"
        }
    }
}
