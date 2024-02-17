import UIKit
import iOSDropDown
import SwiftMessages
class BalanceBankViewController: UIViewController , UITableViewDelegate, UITableViewDataSource ,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate  {
    var client = SQLClient.sharedInstance()
    var list_bankBalance: [BankBalance] = []
    var bank_name: [BankName] = []
    var listPermission: [ScreenPermesiion] = []
    var termBegin = ""
    var termEnd = ""
    var bankNames: [String] = []
    
    var bank_id = 0;
    var _r = 0.0;
    var _rm = 0.0;
    var _rd = 0.0;
    var _rt = 0.0;
    var _rr = 0.0;
    var currentIndex = 0
    var query = ""
    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var bankNameFilter: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bankNameFilter.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "تسجيل خروج", style: .plain, target: self, action: #selector(logOut))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate=self
        tableView.dataSource=self
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePicker))
        toolBar.setItems([btnDone], animated: true)
      searchForBanks(_searchText: "")
        bankNameFilter.backgroundColor = .white
        bankNameFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode


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
//                bankNameFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                bankNameFilter.textColor = isDarkMode ? .white : .black
//                
//               
//              
//               
//            }
//        }
    
   
    func configureDropDown() {
        let nohMostandList = self.bank_name.map { $0.n_acc ?? "" }
            // Set up the Dropdown
        bankNameFilter.optionArray = nohMostandList

        bankNameFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.list_bankBalance
                .filter { $0.n_bank == selectedItem }
                    .compactMap { $0.acc_no }
            self.bank_id = Int(filteredCodMostand.first ?? "") ?? 0
                // Now you can use the filteredCodMostand array as needed.
                print(filteredCodMostand)
                print(self.bank_id)
            }
        }
        
    
    
    
    
    
    
    @IBAction func searchForBanks(_searchText: String) {
        print("connect")
        guard let client = self.client else {
            print(22)
            return
        }
        client.connect("hardsoft.hopto.org:1433", username: "admain", password: "5376274", database: "db_H@rdsoft_2023") {succes in print(succes)
            guard succes else {
                client.disconnect()
                print("Error")
                return
            }
            // ta3dil fe el database column d problem time and date
            
            self.bank_name.removeAll()
            let query2 = " SELECT  TOP 50 n_acc,id_acc FROM name_bank WHERE n_acc LIKE '%\(_searchText)%'"

            client.execute(query2) { results in
                guard let result = results else {
                    print("error")
                    return
                }
                
                print(query2)
                print("true2")
                for table in result {
                    guard let table = table as? NSArray else {
                        print("here2")
                        continue
                    }
                    //                    print(table)
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
                            let instance = try JSONDecoder().decode(BankName.self, from: jsonData)
                            self.bank_name.append(instance)
                            
                            print("bank_name")
                            print(self.bank_name)
                            print("done")
                            //                        print(instance)
                            self.tableView.reloadData()
                            client.disconnect()
                            
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
           let searchText = textField.text ?? ""
           if !searchText.isEmpty {
               let filteredBanks = bank_name.filter { $0.n_acc!.lowercased().contains(searchText.lowercased()) }
               if let firstMatch = filteredBanks.first {
                   let index = bank_name.firstIndex { $0.id_acc == firstMatch.id_acc } ?? 0
                   currentIndex = index
                   bank_id = firstMatch.id_acc ?? 0
//                   bankNameFilter.text = firstMatch.n_acc
               }
           }
        configureDropDown()
        searchForBanks(_searchText: textField.text ?? "")
       }
    @objc func logOut() {
        UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func closePicker(){
        view.endEditing(true)
        if !bank_name.isEmpty && currentIndex < bank_name.count {
                let selectedBank = bank_name[currentIndex]
                bankNameFilter.text = selectedBank.n_acc
            }
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        client?.disconnect()
        print("disconnect")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(list_bankBalance.count)
        return list_bankBalance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bank_balance_cell") as? BalanceBankTableViewCell else { return UITableViewCell() }
        print(indexPath)
        cell.setupCell(
            Cod_bank: list_bankBalance[indexPath.row].cod_bank ?? ""
            , N_bank: list_bankBalance[indexPath.row].n_bank ?? "x"
            , Acc_no: list_bankBalance[indexPath.row].acc_no ?? "x"
            , R: list_bankBalance[indexPath.row].r ?? 0
            , Rm: list_bankBalance[indexPath.row].rm ?? 0
            , Rd: list_bankBalance[indexPath.row].rd ?? 0
            , Rt: list_bankBalance[indexPath.row].rt ?? 0
            , Rr: list_bankBalance[indexPath.row].rr ?? 0
           )
        return cell
    }
    func connect()  {
        query = "Select * from bal_bank_t where id_bank ='" + String(bank_id)  + "' order by no,rr desc"
        print(query)
        print("connect")
        guard let client = self.client else {
            print(22)
            return
        }
        client.connect("hardsoft.hopto.org:1433", username: "admain", password: "5376274", database: "db_H@rdsoft_2023") {succes in print(succes)
            guard succes else {
                client.disconnect()
                print("Error")
                return
            }

            self.list_bankBalance.removeAll()
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
                            let instance = try JSONDecoder().decode(BankBalance.self, from: jsonData)
                            self.list_bankBalance.append(instance)
                            self.bankNames.append(instance.n_bank ?? "empty")
                            self._r += instance.r ?? 0
                            self._rm += instance.rm ?? 0
                            self._rd += instance.rd ?? 0
                            self._rt += instance.rt ?? 0
                            self._rr += instance.rr ?? 0

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
    }
 
    func showAlertWithDetails(r: Double, rm: Double, rd: Double, rt: Double, rr: Double) {
        let message = """
          رصيد فعلي:\(r)
        شيكات وارده: \(rm)
        شيكات صادره: \(rd)
        تحت التسويه: \(rt)
        الاجمالي: \(rr)
        """
        let alert = UIAlertController(title: "الاجمالي", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func show_total(_ sender: Any) {
        print(_r)
        showAlertWithDetails(r: _r, rm: _rm, rd: _rd, rt: _rt, rr: _rr)
    }
    
    func showSnackBar(message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Snack Bar", body: message)
        view.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        SwiftMessages.show(config: config, view: view)
    }
  
    @IBAction func search(_ sender: Any) {
        print("search")
        
        _r = 0.0;
        _rm = 0.0;
        _rd = 0.0;
        _rt = 0.0;
        _rr = 0.0;
        

        connect()
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if(self.list_bankBalance.isEmpty){
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
        return bank_name.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bank_name[row].n_acc
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentIndex = row
        bank_id = bank_name[row].id_acc ?? 0
        bankNameFilter.text = bank_name[row].n_acc
    }
       
   

}


