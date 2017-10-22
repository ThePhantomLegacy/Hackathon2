//
//  ViewController.swift
//  Hackathon
//
//  Created by Eliezer Pla on 10/20/17.
//  Copyright © 2017 Hack. All rights reserved.
//
//minors: purp 56163
//        yell 20666
//        pink 32200
import UIKit
//import Firebase
import UserNotifications
import CoreLocation //Location services
import CoreBluetooth
import SystemConfiguration


class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var textBoop: UILabel!
    
    @IBOutlet var longDip: UILabel!
    
    //Database
    //var ref:DatabaseReference?
    //var handle:DatabaseHandle?
    
    var count = 0
    let mes:[NSNumber:String] = [
        56163:"Fall Danger",//purple
        20666:"Trenching",//yellow
        20604:"Toxic/Hazardous Substance"] //pink
    let mesInfo:[NSNumber:String] = [
        56163:"You best grab your long fall boots or they will be cleaning a splatter",
        20666:"Avoid the small rocks, they result in nil.",
        20604:"There some bad stuff. Put yo raincoat on fool."]
    let mesRad:[NSNumber:Double] = [
        56163: 10,
        20666: 10,
        20604: 10]
    let minors:[NSNumber]=[56163,20666,20604]
    
    /*var minor:[NSNumber] = []
    var name:[String] = []
    var long:[String] = []*/
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimotes")//creating region
    let timeNotification = "timeNotification"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ref = Database.database().reference()
        //print(ref?.child("Nodes").child("Pink").child("Long").description() ?? String.self)
        //print(DatabaseReference.description())
//        let refHandle = ref?.observe(DataEventType.value, with: { (snapshot) in
//            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
//        })
        
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways)
        {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
        
        //Notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter { $0.proximity != CLProximity.unknown}
        //print(knownBeacons.count)
        if(knownBeacons.count > 0 && minors.contains(knownBeacons[0].minor)) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            //print(closestBeacon.minor)
            //self.sendNotification()
            if (closestBeacon.accuracy <= self.mesRad[closestBeacon.minor]!){
                if(count == 0) {
                    
                    self.sendNotification(message: (self.mes[closestBeacon.minor]!))
                    self.view.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
                    textBoop.text = self.mes[closestBeacon.minor]
                    longDip.text = self.mesInfo[closestBeacon.minor]
                    //print(closestBeacon.minor)
                    //print(self.mes[closestBeacon.minor.intValue] as Any)
                    count = 1
                }
            }
            else {
                //count = 0
                textBoop.text = "Non-Hazardous Area"
                longDip.text = " "
                self.view.backgroundColor = UIColor(red: 43, green: 170, blue: 123, alpha: 1)
                count = 0
            }
        }
    
    }
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        self.sendNotification()
//        }
    func sendNotification(message: String){
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.body =  message
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        let notificationRequest = UNNotificationRequest(identifier: timeNotification, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print(error)
            }
            else{
                print("Notification scheduled")
            }
        }
    }
}

