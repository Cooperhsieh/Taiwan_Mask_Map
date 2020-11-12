//
//  DetailViewController.swift
//  Taiwan_Mask_Map
//
//  Created by Cooper on 2020/11/11.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    var maskData : MaskInventory!
   
    
    //MARK: Outlets
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var adultMaskLabel: UILabel!
    @IBOutlet weak var childMaskLabel: UILabel!
    @IBOutlet weak var sellTimeLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var drugstoreName: UILabel!
    
    
    //MARK: Format Time as String
    let dateFormatter: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drugstoreName.text = maskData.name
        phoneLabel.text = maskData?.phone
        addressLabel.text = maskData.address
        adultMaskLabel.text = String(maskData.maskAdult)
        childMaskLabel.text = String(maskData.maskChild)
        sellTimeLabel.text = maskData.note
        
        let timeText = dateFormatter.string(from: maskData.updated)
        updateTimeLabel.text = timeText
    }
    
    
   
}


