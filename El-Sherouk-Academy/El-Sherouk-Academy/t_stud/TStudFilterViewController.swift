//
//  TStudFilterViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 05/11/2023.
//

import UIKit
import SwiftMessages
class TStudFilterViewController: UIViewController  {
    var client: SQLClient?
   
  
    var termBegin = ""
    var termEnd = ""
    var currentIndex = 0
    var query = ""
    var switchOn = false
    var switchOn2 = false

  
    let dateFormatter = DateFormatter()

    
    
  
    @IBOutlet weak var switchCheck: UISwitch!
    @IBOutlet weak var switchCheck2: UISwitch!


    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
             
       
      
        
        
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
    
    
    
   
   
    
    @objc func closePicker(){
        view.endEditing(true)
        
        
    }
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        client?.disconnect()
        print("disconnect")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
      
    
    
    @IBAction func switchChange(_ sender: UISwitch) {
        if sender.isOn {
            switchOn = true
            switchCheck2.isEnabled = false

        } else {
            switchOn = false
            switchCheck2.isEnabled = true

        }
        print(switchOn)  }
    
    @IBAction func switchChange2(_ sender: UISwitch) {
        if sender.isOn {
            switchOn2 = true
            switchCheck.isEnabled = false

        } else {
            switchOn2 = false
            switchCheck.isEnabled = true
        }
        print(switchOn)  }
    
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
                
                if switchOn {
                    print(switchOn)
                 query =   "SELECT gen, '' AS n_cls, SUM(t1) AS t1, SUM(t2) AS t2, SUM(t3) AS t3, SUM(t4) AS t4, SUM(t) AS t, ROW_NUMBER() OVER(ORDER BY gen) AS nn FROM t_stud WHERE d_f <= '" + start_date + "' AND d_t >= '" + end_date + "' GROUP BY gen"
                }
                 if switchOn2 {
                    query = "SELECT gen, n_cls, id_cls, SUM(t1) AS t1, SUM(t2) AS t2, SUM(t3) AS t3, SUM(t4) AS t4, SUM(t) AS t, ROW_NUMBER() OVER(ORDER BY id_cls, gen) AS nn FROM t_stud WHERE d_f <= '" + start_date + "' AND d_t >= '" + end_date + "' GROUP BY gen, n_cls, id_cls"

                    
                }
                
                
              
                
            }
            
            
            
            
            
            if let navigationController = self.navigationController {
                if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? TstudViewController {
                    previousViewController.query = query
                    print("on pop")
                    print(query)
                    navigationController.popViewController(animated: true)
                }
            }
        }
    }
    
}


