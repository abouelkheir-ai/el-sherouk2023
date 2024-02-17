//
//  TstudViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 05/11/2023.
//

import UIKit
import SwiftMessages
class TstudViewController: UIViewController , UITableViewDelegate, UITableViewDataSource   {
    var client = SQLClient.sharedInstance()
    var list_Tstud: [Tsud] = []
    var listPermission: [ScreenPermesiion] = []

    var _t1 = 0;
    var _t2 = 0;
    var _t3 = 0;
    var _t4 = 0;
    var _t5 = 0;
    var _t = 0;


    var termBegin = ""
    var termEnd = ""
    var currentIndex = 0
    var query = ""
    var onPopWithData: ((String) -> Void)?

    
    
    
    @IBOutlet weak var tableView: UITableView!
    

    
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
        if let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "t_stud_filter") as? TStudFilterViewController {
            vcSecondView.termBegin = termBegin
            vcSecondView.termEnd = termEnd
            self.navigationController?.pushViewController(vcSecondView, animated: true)
        } else {
            print("Error: Unable to instantiate view controller with identifier 't_stud_filter'")
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
        print(list_Tstud.count)
       
        return list_Tstud.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "t_stud_cell") as? TstudTableViewCell else { return UITableViewCell() }
        print(indexPath)
      
        
        cell.setupCell(gen: list_Tstud[indexPath.row].gen ?? "", cls: list_Tstud[indexPath.row].n_cls ?? "", t1: list_Tstud[indexPath.row].t1 ?? 0, t2: list_Tstud[indexPath.row].t2 ?? 0, t3: list_Tstud[indexPath.row].t3 ?? 0, t4: list_Tstud[indexPath.row].t4 ?? 0, t: list_Tstud[indexPath.row].t ?? 0)
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

            self.list_Tstud.removeAll()
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
                            let instance = try JSONDecoder().decode(Tsud.self, from: jsonData)
                            self.list_Tstud.append(instance)
                            self._t1 += instance.t1 ?? 0
                            self._t2 += instance.t2 ?? 0
                            self._t3 += instance.t3 ?? 0
                            self._t4 += instance.t4 ?? 0
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
    
 
    func showAlertWithDetails(t1: Int,t2: Int,t3: Int,t4: Int,t: Int) {
        let  message = """
        الكورس: \(t1)
        شهري: \(t2)
        اسبوعي: \(t3)
        يومي: \(t4)
        اجمالي: \(t)

        """
        let alert = UIAlertController(title: "الاجمالي", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func show_total(_ sender: Any) {
        showAlertWithDetails(t1: _t1, t2: _t2, t3: _t3, t4: _t4, t: _t)
    }
    
   
    
    @IBAction func search(_ sender: Any) {
        print("search")
        
        _t1 = 0;
        _t2 = 0;
        _t3 = 0;
        _t4 = 0;
        _t5 = 0;
        _t = 0;

      
        

        connect(_query: query)
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if(self.list_Tstud.isEmpty){
                self.showSnackBar(message: "no data")
            }
        }
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
   
       
   

}



