import UIKit
import iOSDropDown


class BalHourEndFilterViewController: UIViewController ,UITextFieldDelegate  {
    
    
    var client: SQLClient?
    var stud_name: [StudentName] = []
    var stud_name1: [String] = []

    var saf_drasi: [SafDrasi] = []
    var saf_dras1: [String] = []

    var mada: [Mada] = []
    var mada1: [String] = []

    var usersList: [Users] = []
    var usersList1: [String] = []

    var noh_akdList = ["كورس", "شهري", "إسبوعي", "يومي"];
    var idStud = 0;
    var idCls = 0;
    var idstub = 0;

    var currentIndex = 0
    var query = ""
    var nohMostantList: [NohMostand] = []




    
    @IBOutlet weak var studentNameFilter: DropDown!
    
    @IBOutlet weak var levelFilter: DropDown!
    
    @IBOutlet weak var madaFilter: DropDown!
    
    @IBOutlet weak var akdFilter: DropDown!
    
    @IBOutlet weak var userFilter: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        studentNameFilter.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        levelFilter.addTarget(self, action: #selector(saf_drasidDidChange), for: .editingChanged)
        madaFilter.addTarget(self, action: #selector(madadDidChange), for: .editingChanged)
        userFilter.addTarget(self, action: #selector(userdDidChange), for: .editingChanged)
        
        
        
        
        studentNameFilter.optionArray = ["أحمد شاكر ابراهيم", "أحمد فيصل المطيري", "أحمد مناحي الديحاني"]
        studentNameFilter.didSelect{(selectedText , index ,id) in
            self.studentNameFilter.text = "Selected String: \(selectedText) \n index: \(index)"
            
        }
        
        
        
        akdFilter.optionArray = ["كورس", "شهري", "إسبوعي", "يومي"]
           akdFilter.didSelect { (selectedText , index ,id) in
               self.akdFilter.text = "Selected String: \(selectedText) \n index: \(index)"
           }
        
        userFilter.optionArray = usersList1
           akdFilter.didSelect { (selectedText , index ,id) in
               self.akdFilter.text = "Selected String: \(selectedText) \n index: \(index)"
           }
        searchForMada(_searchText: "")
        searchForUser(_searchText: "")
        searchForLevel(_searchText: "")
        searchForStudent(_searchText: "")
        
        studentNameFilter.backgroundColor = .white
        akdFilter.backgroundColor = .white
        userFilter.backgroundColor = .white
        madaFilter.backgroundColor = .white
        levelFilter.backgroundColor = .white
        
        studentNameFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        akdFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        userFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        madaFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        levelFilter.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

        
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
//                levelFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                levelFilter.textColor = isDarkMode ? .white : .black
//                
//               
//                userFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                userFilter.textColor = isDarkMode ? .white : .black
//                
//                madaFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                madaFilter.textColor = isDarkMode ? .white : .black
//                
//                studentNameFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                studentNameFilter.textColor = isDarkMode ? .white : .black
//                
//                akdFilter.backgroundColor = isDarkMode ? .darkGray : .white
//                akdFilter.textColor = isDarkMode ? .white : .black
//                
//              
//                // Update other UI elements similarly
//
//                // Ensure proper visibility and contrast in both light and dark modes
//            }
//        }
    func configureDropDownStudent() {
        let studentNameList = self.stud_name1
            studentNameFilter.optionArray = studentNameList

        studentNameFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.stud_name
                    .filter { $0.n_stud == selectedItem }
                    .compactMap { $0.id_stud }
                self.idStud = Int(filteredCodMostand.first ?? 0)
                print(filteredCodMostand)
                print(self.idStud)
            }
            
       
          }

    func configureDropDownLevel() {
       
        let nohMostandList = self.saf_dras1
            // Set up the Dropdown
            levelFilter.optionArray = nohMostandList

            levelFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.saf_drasi
                    .filter { $0.n_cls == selectedItem }
                    .compactMap { $0.id_cls }
                self.idCls = Int(filteredCodMostand.first ?? 0)
                // Now you can use the filteredCodMostand array as needed.
                print(filteredCodMostand)
                print(self.idCls)
            }
        }
    func configureDropDownMada() {
        
        let nohMostandList = self.mada1
            // Set up the Dropdown
            madaFilter.optionArray = nohMostandList

        madaFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
                let filteredCodMostand = self.mada
                    .filter { $0.n_sub == selectedItem }
                    .compactMap { $0.id_sub }
                self.idstub = Int(filteredCodMostand.first ?? 0)
                // Now you can use the filteredCodMostand array as needed.
                print(filteredCodMostand)
                print(self.idstub)
            }
        }
    func configureDropDownUser() {
     
        let nohMostandList = self.usersList1
            // Set up the Dropdown
            userFilter.optionArray = nohMostandList

            userFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
            }
        }
    func configureDropDownNohAkd() {
        let nohMostandList = noh_akdList
            // Set up the Dropdown
            akdFilter.optionArray = nohMostandList

        akdFilter.didSelect { (selectedItem, index, id) in
                print("Selected item: \(selectedItem) at index \(index)")
              
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
    
   
    
    
    func searchForStudent(_searchText: String) {
        establishDBConnection()

        guard let client = self.client else {
            print("Client not available")
            return
        }
        stud_name.removeAll()
        let query2 = "SELECT TOP 10 n_stud , id_stud FROM name_stud WHERE n_stud LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(StudentName.self, from: jsonData)
                        self.stud_name.append(instance)
                        self.stud_name1.append(instance.n_stud ?? "")
                        print("Student name: \(self.stud_name)")
                        print("Data retrieval complete")

                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
       
    }
    
    func searchForLevel(_searchText: String) {
        establishDBConnection()

        guard let client = self.client else {
            print("Client not available")
            return
        }
        saf_drasi.removeAll()
        let query2 = "SELECT TOP 10 n_cls, id_cls FROM name_cls WHERE n_cls LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(SafDrasi.self, from: jsonData)
                        self.saf_drasi.append(instance)
                        self.saf_dras1.append(instance.n_cls ?? "")

                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
       
    }
    
    func searchForMada(_searchText: String) {
        establishDBConnection()

        guard let client = self.client else {
            print("Client not available")
            return
        }
        mada.removeAll()
        let query2 = "SELECT TOP 10 n_sub , id_sub FROM name_sub WHERE n_sub LIKE '%\(_searchText)%'"
        
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
                        let instance = try JSONDecoder().decode(Mada.self, from: jsonData)
                        self.mada.append(instance)
                        self.mada1.append(instance.n_sub ?? "")

                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
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
       
    }
   
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = stud_name.filter { ($0.n_stud?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = stud_name.firstIndex { $0.n_stud == firstMatch.n_stud } ?? 0
                currentIndex = index
               
            }
        }
        searchForStudent(_searchText: searchText)
        configureDropDownStudent()
       
    }
    @objc func AkdFieldDidChange(_ textField: UITextField) {
        akdFilter.optionArray = ["كورس", "شهري", "إسبوعي", "يومي"]
           akdFilter.didSelect { (selectedText , index ,id) in
               self.akdFilter.text = "Selected String: \(selectedText) \n index: \(index)"
           }
    }
    @objc func saf_drasidDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = saf_drasi.filter { ($0.n_cls?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = saf_drasi.firstIndex { $0.n_cls == firstMatch.n_cls } ?? 0
                currentIndex = index
                //                if let studentName = firstMatch.n_cls {
                //                }
            }
        }
        configureDropDownLevel()

        searchForLevel(_searchText: searchText)
    }
    
    @objc func madadDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = mada.filter { ($0.n_sub?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = mada.firstIndex { $0.n_sub == firstMatch.n_sub } ?? 0
                currentIndex = index
               
            }
        }
        configureDropDownMada()

        searchForMada(_searchText: searchText)
    }
    
    @objc func userdDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            let filteredStudents = usersList.filter { ($0.users?.lowercased() ?? "").contains(searchText.lowercased()) }
            if let firstMatch = filteredStudents.first {
                let index = usersList.firstIndex { $0.users == firstMatch.users } ?? 0
                currentIndex = index
               
            }
        }

        searchForUser(_searchText: searchText)
        userFilter.optionArray = usersList1

    }
    
    
    
    
    
    @objc func closePicker(){
        view.endEditing(true)
        if !stud_name.isEmpty && currentIndex < stud_name.count {
            let selectedStud = stud_name[currentIndex]
            studentNameFilter.text = selectedStud.n_stud
        }
        
        
    }
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        client?.disconnect()
        print("disconnect")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   
   
    
    
    
    @IBAction func passQuery(_ sender: Any) {
        
        query = "SELECT *, inv_user.typ_cont AS typ_cont, inv_user.users AS users, ROW_NUMBER() OVER(ORDER BY n_cls, n_stud) AS nn FROM bal_hour_end INNER JOIN inv_user ON bal_hour_end.inv_no = inv_user.inv_no"

        if (studentNameFilter.text != "") {
            query = query + " AND id_stud = '" + String(idStud) + "'"

        }

        if (levelFilter.text != "") {
            query = query + " AND id_cls = '" + String(idCls) + "'"

        }

        if (madaFilter.text != "") {
            query = query + " AND id_sub = '" + String(idstub) + "'"

        }

        if (userFilter.text != "") {
            query = query + " AND users = '" + (userFilter.text ?? "") + "'"

        }

        if (akdFilter.text != "" ){
            query = query + " AND typ_cont = '" + (akdFilter.text ?? "") + "'"

        }
        query = query + " ORDER BY n_cls, n_stud ASC"
        
        if let navigationController = self.navigationController {
                if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? BalHoudEndViewController {
                    previousViewController.query = query
                    print("on pop")
                    print(query)
                    navigationController.popViewController(animated: true)
                }
            }
    }

    
}


