//
//  ViewController.swift
//  Taiwan_Mask_Map
//
//  Created by Cooper on 2020/11/10.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //生成 CLLocationManager 物件呼叫 requestWhenInUseAuthorization 請求權限
    let locationManager = CLLocationManager()
    
    var getLocation = false
    
    var mask = [MaskInventory]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //記得拉 delegate or 寫code
        mapView.delegate = self
        
        registerMapAnnotationViews()
        
        fetchMaskData()
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: register Annotation
    func registerMapAnnotationViews () {
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(AllMaskAnnotaion.self))
    }
    
    
    //MARK: 抓 API 資料
    func fetchMaskData() {
        guard let url = URL(string: "https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            let decoder = MKGeoJSONDecoder()
            if let features = try? decoder.decode(data) as? [MKGeoJSONFeature] {
                
                let maskAnnotation = features.map {
                    AllMaskAnnotaion(feature: $0)
                }
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(maskAnnotation)
                }
                
            }
        }.resume()
    }
    
    //MARK: 按下按鈕移到 user 當前位置
    @IBAction func locateCurrentLocation(_ sender: Any) {
        var region = MKCoordinateRegion()
        //設定地圖縮放比例，值越小，代表地圖顯示的範圍小但越精細（清楚）
        let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        region.span = span
        mapView.setRegion(region, animated: true)
        mapView.regionThatFits(region)
        //將動畫設為 false，可直接跳過動畫來到 user 位置（不然動畫時間太長）
        mapView.setCenter(mapView.userLocation.coordinate, animated: false)
    }
}



extension MapViewController: MKMapViewDelegate {
    
    //定位 user 附近的位置
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {

        if getLocation == false {
            getLocation = true
            //數字越大，地圖範圍愈大
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1200000, longitudinalMeters: 600000)
            // 依照比例將地圖的中心點做適當的縮放
            mapView.regionThatFits(region)
            mapView.setRegion(region, animated: false)
        }
    }
    
    //讓mapView在呈現時顯示自定義的 annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? AllMaskAnnotaion {
            annotationView = setupAllMaskAnnotationView(for: annotation, on: mapView)
        }
        return annotationView
    }
    
    //使用則會點擊單一 callout 時會跳轉到第二頁呈現資訊
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation = view.annotation as? AllMaskAnnotaion
        if let controller = storyboard?.instantiateViewController(withIdentifier: "DetailNavController") as? DetailViewController {
            
            
            //MARK: 將AllMaskAnnotaion裡的資料帶到第二頁detail
            controller.maskData = annotation?.mask
            show(controller, sender: nil)
        }
    }
    
    
    //MARK: Func for Annotations
    func setupAllMaskAnnotationView (for annotation: AllMaskAnnotaion, on mapView: MKMapView) -> MKAnnotationView {
        
        let identifier = NSStringFromClass(AllMaskAnnotaion.self)
        //重複使用 annotation
        let allMaskView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
        
        allMaskView.canShowCallout = true
        
        let infoButton = UIButton(type: .detailDisclosure)
        allMaskView.rightCalloutAccessoryView = infoButton
        
        let count = Int()
        //判斷：如果成人、兒童口罩都沒有，marker就顯示 🚫
        if count == annotation.mask?.maskAdult, count == 0 && count == annotation.mask?.maskChild, count == 0 {
            allMaskView.image = UIImage(named: "No All Mask")
            //判斷：如果成人都沒有，marker就顯示兒童口罩 👶🏼
        } else if count == annotation.mask?.maskAdult, count == 0 {
            allMaskView.image = UIImage(named: "Child")
            //判斷：如果兒童都沒有，marker就顯示成人口罩 🙆🏻‍♂️
        } else if count == annotation.mask?.maskChild, count == 0 {
            allMaskView.image = UIImage(named: "Adult")
            //判斷：如果成人、兒童口罩都有，marker就顯示 👨‍👩‍👧‍👦
        } else  {
            allMaskView.image = UIImage(named: "family")
        }
        return allMaskView
    }
    
}


