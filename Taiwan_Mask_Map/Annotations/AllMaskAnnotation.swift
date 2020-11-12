//
//  AllMaskAnnotation.swift
//  Taiwan_Mask_Map
//
//  Created by Cooper on 2020/11/10.
//

import MapKit

//MARK: For ALL MASK Include: adult & child
class AllMaskAnnotaion : NSObject, MKAnnotation {
    
    // MARK: MKAnnotation's protocol
    var coordinate: CLLocationCoordinate2D
    
    var mask : MaskInventory?
    
    //MARK: Annotation's Title
    var title: String? {
        mask?.name
    }
    
    //MARK: Annotation's SubTitle
    var subtitle: String? {
        "成人:\(mask?.maskAdult ?? 0)  兒童:\(mask?.maskChild ?? 0)"
    }
    
    
    
    init(feature: MKGeoJSONFeature) {
        
        //MARK: MKGeoJSONFeature 的 property geometry 對應 GeoJSON 的 geometry 欄位，由於它的型別 MKShape 遵從 protocol MKAnnotation，因此我們可用 features[0].geometry[0].coordinate 讀出它的經緯度。
        coordinate = feature.geometry[0].coordinate
        
        //MARK: Decode Data
        if let data = feature.properties {
            let decoder = JSONDecoder()
            //將 properties 欄位的 _ 轉換成沒有底線（e.g. child_Mask）
            decoder.keyDecodingStrategy = .convertFromSnakeCase
//MARK: 使用 enum DateDecodingStrategy 的 case custom((Decoder) throws -> Date) 將時間字串轉換成 Date 型別。
            decoder.dateDecodingStrategy = .custom({ (decorder) -> Date in
                let timeString = try decorder.singleValueContainer().decode(String.self)
                return DateFormatter.customFormatter.date(from: timeString) ?? Date()
            })
            mask = try? decoder.decode(MaskInventory.self, from: data)
        }
    }
}


extension DateFormatter {
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }()
}
