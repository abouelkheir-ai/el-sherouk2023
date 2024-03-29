//
//  AccViewController.swift
//  El-Sherouk-Academy
//
//  Created by mac on 10/11/2023.
//

import UIKit
import SwiftMessages
class AccViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var termBegin = ""
    var termEnd = ""
    var listPermission: [ScreenPermesiion] = []
    var isFound = false
    var filteredItems: [(String, String)] = []
    let searchController = UISearchController(searchResultsController: nil)
    var indexX = -1
    
    let items = [
        ("كشف حساب عام", "image1"),
        
        ("اليوميه العامه", "image2"),
        
        ("بيان بارادات المعهد", "image3"),
        
        ("اجاملي ايرادات المعهد", "image4"),

        ("بيان بمصاريف المعهد", "image4"),
        ("اجمالي مصاريف المعهد", "image4"),
        ("بيان بحركه المستخدمين", "image4"),

        
       
    ]
   
    
    var collectionView: UICollectionView!
    
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
        
//        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.register(AccCardCollectionCell.self, forCellWithReuseIdentifier: "accCardCollectionCell")

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
  
    func showSnackBar(message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Snack Bar", body: message)
        view.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        SwiftMessages.show(config: config, view: view)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter { (title, _) in
                title.localizedCaseInsensitiveContains(searchText)
            }
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filteredItems.isEmpty{
            return items.count
        }else{
            return filteredItems.count

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accCardCollectionCell", for: indexPath) as! AccCardCollectionCell
        
        
        let item: (String, String)
        if filteredItems.isEmpty {
            item = items[indexPath.item]
        } else {
            item = filteredItems[indexPath.item]

        }
        
        cell.configure(title: item.0, imageName: item.1)
        return cell
    }
}
    class AccCardCollectionCell: UICollectionViewCell {
        
        let titleLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont.boldSystemFont(ofSize: 18)
                label.textAlignment = .center
                label.numberOfLines = 0
                return label
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
        
//        func setupColorsForMode() {
//               if #available(iOS 13.0, *) {
//                   let isDarkMode = traitCollection.userInterfaceStyle == .dark
//                   // Define colors for light and dark modes
//                   titleLabel.textColor = isDarkMode ? UIColor.white : UIColor.black
//                   // Set background colors, if needed
//                   backgroundColor = isDarkMode ? UIColor.darkGray : UIColor.white
//                   // You can adapt other elements' colors similarly
//               } else {
//                   backgroundColor = UIColor.white
//                   titleLabel.textColor = UIColor.black
//               }
//           }
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
        
        func setRandomBackgroundColor() {
               self.backgroundColor = UIColor.random()
           }
        
            
            override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                super.traitCollectionDidChange(previousTraitCollection)
                setupColorsForMode()
            }
            
            func configure(title: String, imageName: String) {
                titleLabel.text = title
            }
        
    }
    extension AccViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            
            var  name = ""

            if (filteredItems.isEmpty){
              name = items[indexPath.item].0

            }else{
                name = filteredItems[indexPath.item].0

            }
            print(name)
            if let index = items.lastIndex(where: { $0.0 == name }) {

                indexX = index
                print(index)
                print(indexX)
                // The index variable now contains the index of the item with the specified title
            } else {
                // Handle the case where the specified title is not found in the items array
                print("Item not found in the items array.")
            }
            
            var indexPath = indexPath.item
            if !filteredItems.isEmpty {
                indexPath = indexX
            }
            print(indexPath)
            
            switch indexPath {
            case 0:
               
              
                
                if self.listPermission.count > 0 {
                    
                    
                    for permission in listPermission {
                        if let noForms = permission.no_forms, let sValue = permission.s, noForms == 261, sValue == 1 {
                            isFound = true
                            print("listPermission.count")
                            print(self.listPermission.count)
                            let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "st_acc_ui") as! StAccViewController
                            vcSecondView.termBegin = "2023-09-01"
                            vcSecondView.termEnd = "2024-01-31"
                            vcSecondView.listPermission = listPermission
                            print("listPermission")
                            print(self.listPermission)
                            self.navigationController?.pushViewController(vcSecondView, animated: true)
                            
                            break
                        }else{
                            isFound = false
                            print("no permission")
                        }
                    }
                }else{
                    showSnackBar(message: "ليس لديك صلاحيه")
                }
                break
            case 1:
              
                if self.listPermission.count > 0 {
                    for permission in listPermission {
                        if let noForms = permission.no_forms, let sValue = permission.s, noForms == 262, sValue == 1 {
                            isFound = true
                            print("listPermission.count")
                            print(self.listPermission.count)
                            let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "yama_ui") as! YamaViewController
                            vcSecondView.termBegin = "2023-09-01"
                            vcSecondView.termEnd = "2024-01-31"
                            vcSecondView.listPermission = listPermission
                            print("listPermission")
                            print(self.listPermission)
                            self.navigationController?.pushViewController(vcSecondView, animated: true)
                            
                            break
                        }else{
                            isFound = false
                            print("no permission")
                        }
                    }
                }else{
                    showSnackBar(message: "ليس لديك صلاحيه")
                }
                break
            case 2:
               
               
                if self.listPermission.count > 0 {
                    for permission in listPermission {
                        if let noForms = permission.no_forms, let sValue = permission.s, noForms == 268, sValue == 1 {
                            isFound = true
                            print("listPermission.count")
                            print(self.listPermission.count)
                            let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "t_irad_ui") as! TiradViewController
                            vcSecondView.termBegin = "2023-09-01"
                            vcSecondView.termEnd = "2024-01-31"
                            vcSecondView.listPermission = listPermission
                            print("listPermission")
                            print(self.listPermission)
                            self.navigationController?.pushViewController(vcSecondView, animated: true)
                            
                            break
                        }else{
                            isFound = false
                            print("no permission")
                        }
                    }
                }else{
                    showSnackBar(message: "ليس لديك صلاحيه")
                }
                break
            case 3:
               
               
                
                if self.listPermission.count > 0 {
                    for permission in listPermission {
                        if let noForms = permission.no_forms, let sValue = permission.s, noForms == 268, sValue == 1 {
                            isFound = true
                            print("listPermission.count")
                            print(self.listPermission.count)
                            let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "t_irad_t_ui") as! TiradTViewController
                            vcSecondView.termBegin = "2023-09-01"
                            vcSecondView.termEnd = "2024-01-31"
                            vcSecondView.listPermission = listPermission
                            print("listPermission")
                            print(self.listPermission)
                            self.navigationController?.pushViewController(vcSecondView, animated: true)
                            
                            break
                        }else{
                            isFound = false
                            print("no permission")
                        }
                    }
                }else{
                    showSnackBar(message: "ليس لديك صلاحيه")
                }
              break
            case 4:
                
                // t_masr_t 269 t_masr_t_ui
                // y_users 280
                if self.listPermission.count > 0 {
                    for permission in listPermission {
                        if let noForms = permission.no_forms, let sValue = permission.s, noForms == 269, sValue == 1 {
                            isFound = true
                            print("listPermission.count")
                            print(self.listPermission.count)
                            let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "t_masr_ui") as! TmasrViewController
                            vcSecondView.termBegin = "2023-09-01"
                            vcSecondView.termEnd = "2024-01-31"
                            vcSecondView.listPermission = listPermission
                            print("listPermission")
                            print(self.listPermission)
                            self.navigationController?.pushViewController(vcSecondView, animated: true)
                            
                            break
                        }else{
                            isFound = false
                            print("no permission")
                        }
                    }
                }else{
                    showSnackBar(message: "ليس لديك صلاحيه")
                }
              break
            case 5:
                
                if self.listPermission.count > 0 {
                    for permission in listPermission {
                        if let noForms = permission.no_forms, let sValue = permission.s, noForms == 269, sValue == 1 {
                            isFound = true
                            print("listPermission.count")
                            print(self.listPermission.count)
                            let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "t_masr_t_ui") as! T_masr_TViewController
                            vcSecondView.termBegin = "2023-09-01"
                            vcSecondView.termEnd = "2024-01-31"
                            vcSecondView.listPermission = listPermission
                            print("listPermission")
                            print(self.listPermission)
                            self.navigationController?.pushViewController(vcSecondView, animated: true)
                            
                            break
                        }else{
                            isFound = false
                            print("no permission")
                        }
                    }
                }else{
                    showSnackBar(message: "ليس لديك صلاحيه")
                }
            case 6:
                
                if self.listPermission.count > 0 {
                    for permission in listPermission {
                        if let noForms = permission.no_forms, let sValue = permission.s, noForms == 280, sValue == 1 {
                            isFound = true
                            print("listPermission.count")
                            print(self.listPermission.count)
                            let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "y_users_ui") as! YusersViewController
                            vcSecondView.termBegin = "2023-09-01"
                            vcSecondView.termEnd = "2024-01-31"
                            vcSecondView.listPermission = listPermission
                            print("listPermission")
                            print(self.listPermission)
                            self.navigationController?.pushViewController(vcSecondView, animated: true)
                            
                            break
                        }else{
                            isFound = false
                            print("no permission")
                        }
                    }
                }else{
                    showSnackBar(message: "ليس لديك صلاحيه")
                }
              break
            default:
                // Handle the default case
                break
            }
               
        }
        
    }

extension AccViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContentForSearchText(searchText)
    }
}
