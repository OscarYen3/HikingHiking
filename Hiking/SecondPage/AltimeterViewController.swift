//
//  AltimeterViewController.swift
//  Hiking
//
//  Created by OscarYen on 2019/1/3.
//  Copyright © 2019 OscarYen. All rights reserved.
//


import UIKit
import CoreLocation
import CoreMotion

class AltimeterViewController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet private var gpsAltimeterLabel: UILabel!
    @IBOutlet private var altitudeMarginOfErrorLabel: UILabel!
    @IBOutlet private var altimeterLabel: UILabel!
    @IBOutlet private var altimeterTbv: UITableView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet var myBackground: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ascendLabel: UILabel!
    @IBOutlet weak var descendLabel: UILabel!
    @IBOutlet weak var switchState: UILabel!
    
   
    let locationManger = CLLocationManager()
    let altimeter = CMAltimeter()
    var pedometer = CMPedometer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fixNavigationBar() 
        cheakLocationServices()
        startPedometer()
        startTrackingAltitudeChanges()
        switchState.text = "開始紀錄"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "FFFFFFFF.jpeg")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func startPedometer(){
        
        if CMPedometer.isStepCountingAvailable() && CMPedometer.isDistanceAvailable() && CMPedometer.isFloorCountingAvailable()
        {
            pedometer.startUpdates(from: Date() ,withHandler: { (data:CMPedometerData?, error:Error?) -> Void in
                print("Step:\(data!.numberOfSteps)步")
                print("Distance:\(String(describing: data!.distance))公尺")
                print("Floor Ascend:\(String(describing: data!.floorsAscended))樓")
                print("Floor Descend:\(String(describing: data!.floorsDescended))樓")
                DispatchQueue.main.async {
                    self.stepLabel.text = "\(data!.numberOfSteps)步"
                    self.distanceLabel.text = "\(Int(truncating: data!.distance!))公尺"
                    self.ascendLabel.text = "\(data!.floorsAscended!)樓"
                    self.descendLabel.text = "\(data!.floorsDescended!)樓"
                }
            })
            pedometer.queryPedometerData(from: Date(timeIntervalSinceNow:-24 * 60 * 60), to: Date(), withHandler:{ (data:CMPedometerData?,error:Error?) -> Void in
                print("Step(YesterdayTillNow):\(data!.numberOfSteps)")
                print("Distance(YesterdayTillNow):\(String(describing: data!.distance))")
                print("Ascend(FromYesterday):\(String(describing: data!.floorsAscended))")
                print("Descend(FromYesterday):\(String(describing: data!.floorsDescended))")
            })
        }
    }
    func setupLocationManger(){
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }
    func cheakLocationServices(){
         CLLocationManager.locationServicesEnabled()
            setupLocationManger()
            cheakLocationAuthorization()
    }
    func cheakLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            locationManger.startUpdatingLocation()
            break
        case .denied :
            //show alert instructing them how to turn on permissions
            break
        case.notDetermined:
            locationManger.requestWhenInUseAuthorization()
        case .restricted:
            //show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    func startTrackingAltitudeChanges(){
        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            //TODO : show error alert
            return
        }
        let queue = OperationQueue()
        queue.qualityOfService = .background
        altimeter.startRelativeAltitudeUpdates(to: queue) { (altimeterData, error) in
            if let altimeterData = altimeterData {
                DispatchQueue.main.async {
                    let relativeAltitude   = altimeterData.relativeAltitude as! Double
                    let roundedAltitude  = Double(relativeAltitude.rounded(toDecimalPlace: 2))
                    self.altimeterLabel.text  = "\(roundedAltitude)m"
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let altitude = location.altitude.rounded(toDecimalPlace : 0)
        gpsAltimeterLabel.text = "\(Int(altitude))m"
        altitudeMarginOfErrorLabel.text = "+/-     \(location.verticalAccuracy)m"
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        cheakLocationServices()
    }
    
    @IBAction func altimeterBtnPressed(_ sender: UISwitch) {
        if sender.isOn == true{
            self.stepLabel.text = "步"
            self.distanceLabel.text = "公尺"
            self.ascendLabel.text = "樓"
            self.descendLabel.text = "樓"
             self.altimeterLabel.text = "0.0m"
            startTrackingAltitudeChanges()
            startPedometer()
            switchState.text = "開始紀錄"
        } else {
            switchState.text = "停止紀錄"
            altimeter.stopRelativeAltitudeUpdates()
            pedometer.stopUpdates()
        }
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
extension UIView {
    func takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
    
    


    


