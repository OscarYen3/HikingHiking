//
//  MapViewController.swift
//  Hiking
//
//  Created by OscarYen on 2018/12/20.
//  Copyright © 2018 OscarYen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts


class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

   
    @IBAction func mapBtn(_ sender: Any) {
        cheaklocationServices()
        myMap.userTrackingMode = .follow
    }
    @IBOutlet weak var myMap: MKMapView!
    let locationManager  = CLLocationManager()
    let regionInMeters : Double = 100
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       cheaklocationServices()
        fixNavigationBar() 
        myMap.userTrackingMode = .follow
        myMap.delegate = self
       
        
        
//        let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
//        let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
//
//        // 3.
//        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
//        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
//
//        // 4.
//        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//
//        // 5.
//        let sourceAnnotation = MKPointAnnotation()
//        sourceAnnotation.title = "Times Square"
//
//        if let location = sourcePlacemark.location {
//            sourceAnnotation.coordinate = location.coordinate
//        }
//
//
//        let destinationAnnotation = MKPointAnnotation()
//        destinationAnnotation.title = "Empire State Building"
//
//        if let location = destinationPlacemark.location {
//            destinationAnnotation.coordinate = location.coordinate
//        }
//
//        // 6.
//        self.myMap.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
//
//        // 7.
//        let directionRequest = MKDirections.Request()
//        directionRequest.source = sourceMapItem
//        directionRequest.destination = destinationMapItem
//        directionRequest.transportType = .automobile
//
//        // 计算方向
//        let directions = MKDirections(request: directionRequest)
//
//        // 8.
//        directions.calculate {
//            (response, error) -> Void in
//
//            guard let response = response else {
//                if let error = error {
//                    print("Error: \(error)")
//                }
//                return
//            }
//            let route = response.routes[0]
//            self.myMap.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
//
//            let rect = route.polyline.boundingMapRect
//            self.myMap.setRegion(MKCoordinateRegion(rect), animated: true)
//        }
    
        myMap.addAnnotation(artwork1)
        myMap.addAnnotation(artwork2)
        myMap.addAnnotation(artwork3)
        myMap.addAnnotation(artwork4)
        myMap.addAnnotation(artwork5)
        myMap.addAnnotation(artwork6)
        myMap.addAnnotation(artwork7)
        
        myMap.addAnnotation(artwork8)
        myMap.addAnnotation(artwork9)
        myMap.addAnnotation(artwork10)
        myMap.addAnnotation(artwork11)
        myMap.addAnnotation(artwork12)
        myMap.addAnnotation(artwork13)
        myMap.addAnnotation(artwork14)
        myMap.addAnnotation(artwork15)
        myMap.addAnnotation(artwork16)
        
        myMap.addAnnotation(artwork17)
        myMap.addAnnotation(artwork18)
        myMap.addAnnotation(artwork19)
        myMap.addAnnotation(artwork20)
        myMap.addAnnotation(artwork21)
        myMap.addAnnotation(artwork22)
        myMap.addAnnotation(artwork23)
        myMap.addAnnotation(artwork24)
        myMap.addAnnotation(artwork25)
        myMap.addAnnotation(artwork26)
        
        myMap.addAnnotation(artwork27)
        myMap.addAnnotation(artwork28)
        myMap.addAnnotation(artwork29)
        myMap.addAnnotation(artwork30)
        myMap.addAnnotation(artwork31)
        myMap.addAnnotation(artwork32)
        myMap.addAnnotation(artwork33)
        myMap.addAnnotation(artwork34)
        myMap.addAnnotation(artwork35)
        myMap.addAnnotation(artwork36)
        myMap.addAnnotation(artwork37)
        
        myMap.addAnnotation(artwork38)
        myMap.addAnnotation(artwork39)
        myMap.addAnnotation(artwork40)
        myMap.addAnnotation(artwork41)
        myMap.addAnnotation(artwork42)
        
        myMap.addAnnotation(artwork43)
        myMap.addAnnotation(artwork44)
        
        myMap.addAnnotation(artwork45)
        myMap.addAnnotation(artwork46)
        myMap.addAnnotation(artwork47)
        myMap.addAnnotation(artwork48)
        myMap.addAnnotation(artwork49)
        myMap.addAnnotation(artwork50)
        
    }
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        renderer.strokeColor = UIColor.red
//        renderer.lineWidth = 4.0
//
//        return renderer
//    }
    
    func allowsBackgroundLocationUpdates(){
    locationManager.activityType = .automotiveNavigation
    if #available(iOS 9.0, *) {
    locationManager.allowsBackgroundLocationUpdates = true  //多工背後執行
    } else {
    // Fallback on earlier versions
    }
    locationManager.startUpdatingLocation()
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center:location,latitudinalMeters:regionInMeters,longitudinalMeters:regionInMeters)
              myMap.setRegion(region, animated: true)
            print(location.latitude,location.longitude)
        }
    }
    func cheaklocationServices(){
         CLLocationManager.locationServicesEnabled()
            setupLocationManager()
            cheakLocationAuthorzation()
        }
    
    func cheakLocationAuthorzation(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            myMap.showsUserLocation = true
            centerViewOnUserLocation()
            //locationManager.stopUpdatingLocation()
        
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        case .denied:
            break
        @unknown default:
            break
        }
    }

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location:CLLocation = locations.last else { return }
    print("Lat:\(location.coordinate.latitude) Lon:\(location.coordinate.longitude)")
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let region = MKCoordinateRegion.init(center:center,latitudinalMeters: regionInMeters,longitudinalMeters: regionInMeters)
        myMap.setRegion(region, animated: true)
    //            locationManager.distanceFilter = CLLocationDistance(10); //表示移動10公尺再更新座標資訊
  // var distance:CLLocationDistance = location.distanceFromLocation(artwork1)
// print("两点间距离是：\(distance)")
}
func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    cheakLocationAuthorzation()
}

   
    
var artwork1 = Artwork(title: "忠義山步道",locationName: "北投區",coordinate:
    CLLocationCoordinate2D(latitude:25.137000, longitude: 121.478639))
var artwork2 = Artwork(title: "下青礐步道",locationName: "北投區",coordinate:
    CLLocationCoordinate2D(latitude:25.151694, longitude: 121.493889))
var artwork3 = Artwork(title: "郵政訓練所步道",locationName: "北投區",coordinate:
    CLLocationCoordinate2D(latitude:25.148111 ,longitude:  121.51413))
var artwork4 = Artwork(title: "中正山親山步道",locationName: "北投區",coordinate:
    CLLocationCoordinate2D(latitude:25.149944 ,longitude: 121.522111))
var artwork5 = Artwork(title: "軍艦岩步道",locationName: "北投區",coordinate:
    CLLocationCoordinate2D(latitude:25.123806, longitude:121.517111))
var artwork6 = Artwork(title: "水尾巴拉卡步道",locationName: "北投區",coordinate:
    CLLocationCoordinate2D(latitude:25.187917,  longitude:121.521361))
var artwork7 = Artwork(title: "泉源里紗帽步道",locationName: "北投區",coordinate:
    CLLocationCoordinate2D(latitude:25.147722,  longitude:121.530694))
var artwork8 = Artwork(title: "仙跡岩步道1號路線",locationName: "文山區",coordinate:
    CLLocationCoordinate2D(latitude:24.990889, longitude:  121.543417))
var artwork9 = Artwork(title: "仙跡岩步道2號路線",locationName: "文山區",coordinate:
    CLLocationCoordinate2D(latitude:24.990889, longitude:  121.543417))
var artwork10 = Artwork(title: "仙跡岩步道試院支線",locationName: "文山區",coordinate:
    CLLocationCoordinate2D(latitude:24.988611, longitude: 121.547361))
var artwork11 = Artwork(title: "仙跡岩步道麥田支線",locationName: "文山區",coordinate:
    CLLocationCoordinate2D(latitude:24.996806,  longitude:121.551083))
var artwork12 = Artwork(title: "指南宮步道",locationName: "文山區",coordinate:
    CLLocationCoordinate2D(latitude:24.981111, longitude: 121.585278))
var artwork13 = Artwork(title: "飛龍步道",locationName: "文山區",coordinate:
    CLLocationCoordinate2D(latitude:24.974222, longitude: 121.580444))
var artwork14 = Artwork(title: "樟樹步道",locationName: "文山區",coordinate:
    CLLocationCoordinate2D(latitude:24.967306, longitude: 121.587389))
var artwork15 = Artwork(title: "樟湖步道",locationName: "文山區",coordinate:
    CLLocationCoordinate2D(latitude:24.966861, longitude: 121.587417))
var artwork16 = Artwork(title: "猴山岳步道",locationName: "文山區",coordinate:
    CLLocationCoordinate2D(latitude:24.978972, longitude: 121.590861))
var artwork17 = Artwork(title: "大崙頭山步道",locationName: "內湖區",coordinate:
    CLLocationCoordinate2D(latitude:25.106222,  longitude: 121.583667))
var artwork18 = Artwork(title: "金面山步道",locationName: "內湖區",coordinate:
    CLLocationCoordinate2D(latitude:25.088556, longitude:  121.568056))
var artwork19 = Artwork(title: "忠勇山步道",locationName: "內湖區",coordinate:
    CLLocationCoordinate2D(latitude:25.092556, longitude:  121.585472))
var artwork20 = Artwork(title: "忠勇山越嶺步道",locationName: "內湖區",coordinate:
    CLLocationCoordinate2D(latitude:25.100306,  longitude: 121.575806))
var artwork21 = Artwork(title: "龍船岩步道",locationName: "內湖區",coordinate:
    CLLocationCoordinate2D(latitude:25.103417,  longitude: 121.596222))
var artwork22 = Artwork(title: "鯉魚山步道",locationName: "內湖區",coordinate:
    CLLocationCoordinate2D(latitude:25.090389, longitude: 121.596056 ))
var artwork23 = Artwork(title: "圓覺寺步道",locationName: "內湖區",coordinate:
    CLLocationCoordinate2D(latitude:25.097583, longitude: 121.590861 ))
var artwork24 = Artwork(title: "大溝溪畔步道",locationName: "內湖區",coordinate:
    CLLocationCoordinate2D(latitude:25.088778,  longitude:121.598500))
var artwork25 = Artwork(title: "碧湖步道",locationName: "內湖區",coordinate:
    CLLocationCoordinate2D(latitude:25.088778,  longitude: 121.598500))
var artwork26 = Artwork(title: "白鷺鷥山步道",locationName: "內湖區",coordinate:
    CLLocationCoordinate2D(latitude:25.078389, longitude: 121.606806))
var artwork27 = Artwork(title: "拇指山步道",locationName: "信義區",coordinate:
    CLLocationCoordinate2D(latitude:25.027444, longitude:  121.570806))
var artwork28 = Artwork(title: "虎山奉天宮步道",locationName: "信義區",coordinate:
    CLLocationCoordinate2D(latitude:25.037167,longitude: 121.585139 ))
var artwork29 = Artwork(title: "虎山120高地步道",locationName: "信義區",coordinate:
    CLLocationCoordinate2D(latitude:25.034833, longitude:  121.585250))
var artwork30 = Artwork(title: "虎山吉福宮步道",locationName: "信義區",coordinate:
    CLLocationCoordinate2D(latitude:25.036250,longitude: 121.581472 ))
var artwork31 = Artwork(title: "虎山生態步道",locationName: "信義區",coordinate:
    CLLocationCoordinate2D(latitude:25.033111, longitude:  121.590444))
var artwork32 = Artwork(title: "虎山自然步道",locationName: "信義區",coordinate:
    CLLocationCoordinate2D(latitude:25.036306, longitude:  121.587444))
var artwork33 = Artwork(title: "虎山山腰步道",locationName: "信義區",coordinate:
    CLLocationCoordinate2D(latitude:25.032250, longitude:  121.591028))
var artwork34 = Artwork(title: "虎山溪步道",locationName: "信義區",coordinate:
    CLLocationCoordinate2D(latitude:25.036306, longitude:  121.587444))
var artwork35 = Artwork(title: "象山永春崗步道",locationName: "信義區",coordinate:
    CLLocationCoordinate2D(latitude:25.031528, longitude:  121.577861))
var artwork36 = Artwork(title: "象山北星寶宮步道",locationName: "信義區",coordinate:
    CLLocationCoordinate2D(latitude:25.027389, longitude:  121.570833))
var artwork37 = Artwork(title: "象山一線天步道",locationName: "信義區",coordinate:
    CLLocationCoordinate2D(latitude:25.027389,longitude:  121.570833))
var artwork38 = Artwork(title: "水管路步道",locationName: "士林區",coordinate:
    CLLocationCoordinate2D(latitude:25.127611,  longitude:  121.533611))
var artwork39 = Artwork(title: "下竹林步道",locationName: "士林區",coordinate:
    CLLocationCoordinate2D(latitude:25.133583,  longitude: 121.542722))
var artwork40 = Artwork(title: "婆婆橋步道",locationName: "士林區",coordinate:
    CLLocationCoordinate2D(latitude:25.099333,  longitude: 121.555917))
var artwork41 = Artwork(title: "大崙頭山森林步道",locationName: "士林區",coordinate:
    CLLocationCoordinate2D(latitude:25.113083,  longitude: 121.581639))
var artwork42 = Artwork(title: "大崙頭山自然步道",locationName: "士林區",coordinate:
    CLLocationCoordinate2D(latitude:25.113083,  longitude: 121.581639))
var artwork43 = Artwork(title: "劍潭山步道主線",locationName: "中山區",coordinate:
    CLLocationCoordinate2D(latitude:25.078639,  longitude: 121.529639))
var artwork44 = Artwork(title: "劍潭山步道劍潭公園副線",locationName: "中山區",coordinate:
    CLLocationCoordinate2D(latitude:25.080750,  longitude: 121.524444))
var artwork45 = Artwork(title: "示範茶廠環山步道",locationName: "南港區",coordinate:
    CLLocationCoordinate2D(latitude:25.026500, longitude: 121.663444))
var artwork46 = Artwork(title: "桂花吊橋步道",locationName: "南港區",coordinate:
    CLLocationCoordinate2D(latitude:25.024972,  longitude: 121.661806))
var artwork47 = Artwork(title: "更寮步道",locationName: "南港區",coordinate:
    CLLocationCoordinate2D(latitude:25.032722, longitude:  121.631639))
var artwork48 = Artwork(title: "栳寮步道",locationName: "南港區",coordinate:
    CLLocationCoordinate2D(latitude:25.034028, longitude: 121.635972 ))
var artwork49 = Artwork(title: "中華技術學院步道",locationName: "南港區",coordinate:
    CLLocationCoordinate2D(latitude:25.033722, longitude:  121.609861))
var artwork50 = Artwork(title: "九五峰步道",locationName: "南港區",coordinate:
    CLLocationCoordinate2D(latitude:25.032639, longitude:  121.594389))
    
    
    
    

    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Artwork else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = myMap.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    func fixNavigationBar() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.darkGray
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
            navigationItem.compactAppearance = appearance
        }
    }
    
}


