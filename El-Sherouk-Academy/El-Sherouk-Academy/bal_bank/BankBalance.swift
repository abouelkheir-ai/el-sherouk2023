//
//  BalanceBank.swift
//  El-Sherouk-Academy
//
//  Created by mac on 24/10/2023.
//

import Foundation
struct BankBalance : Codable {
    let cod_bank:String?
    let n_bank:String?
    let acc_no:String?
    let r:Double?
    let rm:Double?
    let rd:Double?
    let rt:Double?
    let rr:Double?
  
}

struct BankName: Codable {
    let n_acc: String?
    let id_acc: Int?
   
}
