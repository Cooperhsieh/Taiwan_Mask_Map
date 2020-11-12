//
//  MaskInventory.swift
//  Taiwan_Mask_Map
//
//  Created by Cooper on 2020/11/10.
//

import Foundation

//MARK: For GeoJson's properties to decode
struct MaskInventory: Decodable {
    let name: String
    let phone: String
    let address: String
    //大人口罩數量
    let maskAdult: Int
    //兒童口罩數量
    let maskChild: Int
    let updated: Date
    let available: String
    let note: String
    let customNote: String
    let website: String
    let county: String
    let town: String
    let cunli: String
    let servicePeriods: String
    
}

