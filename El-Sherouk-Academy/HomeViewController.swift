import UIKit
import SwiftMessages
class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var termBegin = ""
    var termEnd = ""
    var userName = ""
    var listPermission: [ScreenPermesiion] = []
    var client: SQLClient?
    var dateTerm: [DateTerm] = []
    var listIdPerm: [NameUsers] = []
    var id_perm = "0"
    var term = "تيرم أول 2024"
    var isFound = false
    let items = [
        ("المجموعات", "image1"),
        ("المبيعات", "image2"),
        ("الموارد البشريه", "image3"),
        ("سندات ", "image4"),
        ("تقارير محاسبيه", "image5")
    ]
    
    var collectionView: UICollectionView!
    var refreshButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.width - 60 - layout.minimumInteritemSpacing) / 2

        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 50, left: 20, bottom: 20, right: 20)
        layout.itemSize = CGSize(width: width, height: 150)
            layout.minimumLineSpacing = 20
            layout.minimumInteritemSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCollectionViewCell")
//        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
                navigationItem.rightBarButtonItem = refreshButton
        
        getUserId(_searchText: userName) { [weak self] in
            guard let self = self else { return }

            searchForPermissions(_searchText: String(id_perm)) { [weak self] in
                guard let self = self else { return }
                
            }
        }
        if userName == "demo@gmail.com" {
                // Grant full access - populate listPermission with all available screens
            
            for i in 1...301 {
                listPermission.append(ScreenPermesiion(no_forms: i, s: 1))
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
    func showSnackBar(message: String, withHappyFace: Bool = false) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Snack Bar", body: message)
//        view.configureContent(body: message)
        view.button?.isHidden = true

        if withHappyFace {
            view.configureTheme(.success)

                    // Add your smiley face image
                    let smileyFaceImageView = UIImageView(image: UIImage(named: "happy_face_icon"))
                    smileyFaceImageView.contentMode = .scaleAspectFit
                    view.iconImageView = smileyFaceImageView
        }

        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        SwiftMessages.show(config: config, view: view)
    }

    @objc func refreshButtonTapped() {
            // Handle the refresh button tap
            print("Refresh button tapped")
        listPermission.removeAll()
        
        getUserId(_searchText: userName) { [weak self] in
            guard let self = self else { return }

            searchForPermissions(_searchText: String(id_perm)) { [weak self] in
                guard let self = self else { return }

               
                
            }
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
        let item = items[indexPath.item]
        cell.configure(title: item.0, imageName: item.1)
        return cell
    }
}

class CardCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
        
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
            setupColorsForMode()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    
    func setupViews() {
        addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor), // Center horizontally
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor), // Center vertically
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            ])
    }
    func setupColorsForMode() {
            if #available(iOS 13.0, *) {
                let isDarkMode = traitCollection.userInterfaceStyle == .dark
                backgroundColor = isDarkMode ?  UIColor.darkGray : UIColor.white
                // Apply other styles based on mode
                layer.cornerRadius = isDarkMode ? 10 : 10 // Adjust corner radius based on mode
                layer.shadowColor = isDarkMode ? UIColor.clear.cgColor : UIColor.lightGray.cgColor
                layer.shadowOpacity = isDarkMode ? 0.8 : 0.8 // Adjust shadow opacity based on mode
                layer.shadowOffset = CGSize(width: 0, height: 2) // Adjust shadow offset based on mode
                layer.shadowRadius = isDarkMode ? 4 : 4 // Adjust shadow radius based on mode
            } else {
                backgroundColor = UIColor.white
                layer.cornerRadius = 10 // For non-iOS 13 devices, apply a default corner radius
                layer.shadowColor = UIColor.lightGray.cgColor
                layer.shadowOpacity = 0.8
                layer.shadowOffset = CGSize(width: 0, height: 2)
                layer.shadowRadius = 4
            }
        }
    
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            setupColorsForMode()
        }
        
        func configure(title: String, imageName: String) {
            titleLabel.text = title
//                imageView.image = UIImage(named: imageName)
        }
    

    func setRandomBackgroundColor() {
           self.backgroundColor = UIColor.random()
       }
   
        
       
    
}
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch indexPath.item {
            case 0 :
            
            print("selected 0")
            let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "groups_table_ui") as! GroupsAndTimeTableViewController
            vcSecondView.termBegin = "2023-09-01"
            vcSecondView.termEnd = "2024-01-31"
            vcSecondView.listPermission = listPermission
            self.navigationController?.pushViewController(vcSecondView, animated: true)
            
            
            //            wrk_ord_g 174
            //            wrk_ord_f 175
            //            name_stud_g 176
            //            name_stud_f 177
            //            bal_hour_f 179
            //            bal_hour_f_t 180
            //            st_hour_f 181
            //            y_att_abs_f 182
            //            y_abs_fardi 183
            //            y_att_abs_group 184
            //            y_att_abs_group_t 185
            //            y_att_abs_group_tt 186
            //            y_stud_behv  188
            //            name_stud_end 190
            //            bal_hour_end 191
           
        

            break
            case 1 :
            
            // bal_kast 202
            // bal_kast_u 202
            // st_stud 204
            // st_f_stud 205
            // y_disc_inv 206
            // y_inv 207
            // y_inv_u 207
            // t_stud 208
            // y_stop_kast 209
            // y_rej_renew 211
            // y_new_cont 212
            // t_user 214
            // bal_target_k 215
            
            print("selected 1")
            let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "sales_ui") as! SalesViewController
            vcSecondView.termBegin = "2023-09-01"
            vcSecondView.termEnd = "2024-01-31"
            vcSecondView.listPermission = listPermission
            self.navigationController?.pushViewController(vcSecondView, animated: true)
            
            
            break
            case 2 :
            
            // y_cont_moz 221
            // y_resign_moz 222
            // y_clr_moz 223
            // y_acc_moz 224
            // y_cont_clr_moz 227
            // y_gaz_sol_mok 227
            // y_moz_date 230
            
            print("selected 2")
            let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "Hr_ui") as! HrViewController
            vcSecondView.termBegin = "2023-09-01"
            vcSecondView.termEnd = "2024-01-31"
            vcSecondView.listPermission = listPermission
            self.navigationController?.pushViewController(vcSecondView, animated: true)
            break
            case 3 :
            // bal_kaz 241
            // st_kaz 242
            // bal_bank 245
            // st_bank 246
            // st_bank_t 246
            print("selected 3")
            let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "sanadat_ui") as! sanadatViewController
            vcSecondView.termBegin = "2023-09-01"
            vcSecondView.termEnd = "2024-01-31"
            vcSecondView.listPermission = listPermission
            self.navigationController?.pushViewController(vcSecondView, animated: true)
            break
            case 4 :
            
            print("selected 4")
            let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "acc_ui") as! AccViewController
            vcSecondView.termBegin = "2023-09-01"
            vcSecondView.termEnd = "2024-01-31"
            vcSecondView.listPermission = listPermission
            self.navigationController?.pushViewController(vcSecondView, animated: true)
            break
        default:
            break
        }
           
        print("Item at index \(indexPath.item) was clicked.")
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
    func getUserId(_searchText: String, completion: @escaping () -> Void) {
        establishDBConnection()
        guard let client = self.client else {
            print("Client not available")
            return
        }
        let query2 = "SELECT id_perm FROM name_user WHERE email = '" + _searchText + "'"
        
        client.execute(query2) { results in
            guard let result = results else {
                print("Error retrieving data")
                self.showSnackBar(message: "Connection error")


                return
            }
            self.showSnackBar(message: "Permission Granted", withHappyFace: true)

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
//                    print(row)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: row)
                        let instance = try JSONDecoder().decode(NameUsers.self, from: jsonData)
                        self.listIdPerm.append(instance)
                        self.id_perm = instance.id_perm ?? ""
//                        print(self.listPermission.count)
                       
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            completion() // Call the completion handler when the data retrieval is complete
        }
    }
    func searchForPermissions(_searchText: String, completion: @escaping () -> Void) {
        establishDBConnection()
        guard let client = self.client else {
            print("Client not available")
            return
        }
        let query2 = "SELECT no_forms, s FROM slahiat WHERE id_perm = '" + _searchText + "'"
        
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
//                    print(row)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: row)
                        let instance = try JSONDecoder().decode(ScreenPermesiion.self, from: jsonData)
                        self.listPermission.append(instance)
//                        print(self.listPermission.count)
                       
                        print("Data retrieval complete")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            completion() // Call the completion handler when the data retrieval is complete
        }
    }
}
