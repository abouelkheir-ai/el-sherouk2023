//
//  StStudViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 06/11/2023.
//

import UIKit
import SwiftMessages
class StStudViewController: UIViewController , UITableViewDelegate, UITableViewDataSource   {
    var client = SQLClient.sharedInstance()
    var list_stStud: [StStud] = []
    
    var listPermission: [ScreenPermesiion] = []

    var _madin = 0.0;
    var _dain = 0.0;
    var _r = 0.0;

    var teacher = ""
    var level = ""
    var termBegin = ""
    var termEnd = ""
    var currentIndex = 0
    var query = ""
    var onPopWithData: ((String) -> Void)?

    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var teacherName: UILabel!
    
    @IBOutlet weak var levelName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "تسجيل خروج", style: .plain, target: self, action: #selector(logOut))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate=self
        tableView.dataSource=self
       
        

    }
   
    func showSnackBar(message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Snack Bar", body: message)
        view.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        SwiftMessages.show(config: config, view: view)
    }
   
    
    @IBAction func goFilter(_ sender: Any) {
        print("goFilter tapped")
        if let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "st_stud_filter_ui") as? StStudFilterViewController {
            vcSecondView.termBegin = termBegin
            vcSecondView.termEnd = termEnd
            self.navigationController?.pushViewController(vcSecondView, animated: true)
        } else {
            print("Error: Unable to instantiate view controller with identifier 'st_stud_filter_ui'")
        }

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
        print(list_stStud.count)
        
        return list_stStud.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "st_stud_cell") as? StStudTableViewCell else { return UITableViewCell() }
        print(indexPath)

        cell.setupCell(dates: list_stStud[indexPath.row].dates ?? "", nohmostand: list_stStud[indexPath.row].noh_mostand ?? "", mostand: list_stStud[indexPath.row].mostand ?? "", typ_inv: list_stStud[indexPath.row].typ_inv ?? "", typ_cont: list_stStud[indexPath.row].typ_cont ?? "", users: list_stStud[indexPath.row].users ?? "", d_f: list_stStud[indexPath.row].d_f ?? "", d_t: list_stStud[indexPath.row].d_t ?? "", madin: list_stStud[indexPath.row].madin ?? 0, dain: list_stStud[indexPath.row].dain ?? 0)
        return cell
    }
    func connect(_query : String)  {
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

            self.list_stStud.removeAll()
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
                            let instance = try JSONDecoder().decode(StStud.self, from: jsonData)
                            self.list_stStud.append(instance)
                            self._madin += instance.madin ?? 0
                            self._dain += instance.dain ?? 0
                            self._r = self._madin - self._dain
                            
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
    
 
    func showAlertWithDetails(madin: Double, dain: Double, r: Double) {
        let  message = """
        مدين: \(madin)
        داين:\(dain)
        رصيد طالب:\(r)

        """
        let alert = UIAlertController(title: "الاجمالي", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func show_total(_ sender: Any) {
        showAlertWithDetails(madin: _madin, dain: _dain, r: _r)
    }
    
   
    
    @IBAction func search(_ sender: Any) {
        print("search")
        
        _madin = 0.0;
        _dain = 0.0;
        _r = 0.0;
        
      
        levelName.text = level
        teacherName.text = teacher

        connect(_query: query)
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if(self.list_stStud.isEmpty){
                self.showSnackBar(message: "message")
            }
        }
        
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
   
       
   

}



