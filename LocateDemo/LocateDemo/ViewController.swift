//
//  ViewController.swift
//  LocateDemo
//
//  Created by panda zheng on 16/8/14.
//  Copyright © 2016年 pandazheng. All rights reserved.
//

import UIKit
import MapKit
import CloudKit
import CoreLocation


class ViewController: UIViewController , CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    
    var lastKnownLocation : CLLocation?

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
    }

    @IBAction func updateLocation(sender: AnyObject) {
        
        let authCode = CLLocationManager.authorizationStatus()
        
        if authCode == CLAuthorizationStatus.NotDetermined && locationManager.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization)) {
            if NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription") != nil {
                locationManager.requestWhenInUseAuthorization()
            } else {
                print("No description provided")
            }
        } else {
            getLocation()
        }
    }
    
    func getLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        if let currentLocation = locations.first {
            
            lastKnownLocation = currentLocation
            let currentPosition = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: currentPosition, span: coordinateSpan)
            
            mapView.setRegion(region, animated: true)
            
            let positionPin = MKPointAnnotation()
            positionPin.coordinate = currentPosition
            positionPin.title = "Your position"
            positionPin.subtitle = "What an awesome place"
            
            
            mapView.addAnnotation(positionPin)
        }
    }
    
    @IBAction func shareLocation(sender: AnyObject) {
        if lastKnownLocation != nil {
            let database = CKContainer.defaultContainer().publicCloudDatabase
            
            let locationAlert = UIAlertController(title: "Your Location", message: "Enter a title for your shared Location", preferredStyle: .Alert)
            
            locationAlert.addTextFieldWithConfigurationHandler({ (textfield:UITextField) in
                textfield.placeholder = "Your location"
            })
            
            locationAlert.addAction(UIAlertAction(title: "Send", style: .Default, handler: { (action : UIAlertAction) in
                if let textFieldContent = locationAlert.textFields?.first?.text where locationAlert.textFields?.first?.text != "" {
                    let newLocation = CKRecord(recordType: "Position")
                    newLocation["locationTitle"] = textFieldContent
                    newLocation["sharedLocation"] = self.lastKnownLocation!
                    
                    database.saveRecord(newLocation, completionHandler: { (record:CKRecord?, error:NSError?) in
                        if error != nil {
                            print("Did save location \(record)")
                        }
                    })
                }
            }))
            
            locationAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            self.presentViewController(locationAlert, animated: true, completion: nil)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

