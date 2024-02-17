//
//  FilterStruc.swift
//  El-Sherouk-Academy
//
//  Created by mac on 28/10/2023.
//

import Foundation


struct Father: Codable {
    let n_f_stud: String?
    let id_f_stud:Int?

}
struct StudentName: Codable {
    let n_stud: String?
    let id_stud: Int?
   
}
struct SafDrasi: Codable {
    let n_cls: String?
    let id_cls:Int?

}
struct Mada: Codable {
    let n_sub: String?
    let id_sub:Int?

}
struct Users: Codable {
    let users: String?
   
}
struct Location: Codable {
    let n_area: String?
    let id_area:Int?

   
}
struct Employee: Codable {
    let n_moz: String?
    let id_moz:String?
   
}
struct KazName: Codable {
    let n_acc: String?
    let id_acc:Int?
   
}
struct Permissions: Codable {
    let s: Int?
   
}
struct NohMostand: Codable {
    let noh_mostand: String?
    let cod_mostand: String?

    
}

struct Wazefa: Codable {
    let n_waz: String?
    let id_waz: Int?
}

struct WorkTime: Codable {
    let n_wrk_time: String?
    let id_wrk_time: Int?


    
}
struct NGroup: Codable {
    let n_group: String?
    let id_group: Int?


    
}

struct StudentNameS: Codable {
    let n_cls: String?
    let n_moz: String?


    
}

struct LR: Codable {
    let lr: Double?


    
}
struct Nacc: Codable {
    let n_acc: String?
    let id_acc: Int?


    
}
struct Gov: Codable {
    let n_gov: String?
    let id_gov: Int?


    
}
struct NhowInst: Codable {
    let n_how_inst: String?
    let id_how_inst: Int?


    
}
struct NrepCall: Codable {
    let n_rep_call: String?
    let id_rep_call: Int?


    
}
struct Nschool: Codable {
    let n_school: String?
    let id_school: Int?


    
}
struct ScreenPermesiion: Codable {
    let no_forms: Int?
    let s: Int?
}

struct NameUsers: Codable {
    let id_perm: String?
}

