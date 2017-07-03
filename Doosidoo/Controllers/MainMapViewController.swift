//
//  MainMapViewController.swift
//  Doosidoo
//
//  Created by Komsit Developer on 4/9/2560 BE.
//  Copyright © 2560 Doosidoo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MainMapViewController: UIViewController {
    @IBOutlet weak var _mapView: MKMapView!
    
    var pointAnnotation: CustomPointAnnotation?
    var pinAnnotationView: MKPinAnnotationView?
    var locationManager: CLLocationManager?
    var location: CLLocation?
    var timer: Timer?
    
    func setViews() {
        let mqtt = MqttModel.sharedInstance
        mqtt.delegate = self
        mqtt.subscribeToChannel(subChannel: "") { (success, error) in
            
        }
        self.title = UserModel.fullNameOfSignedInUser()
    }
    
    func setLocationManager() {
        // location
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestAlwaysAuthorization()
        locationManager?.activityType = .otherNavigation
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = kCLDistanceFilterNone
        //locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.setLocationManager()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.zoomMapUserCurrent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func zoomMapUserCurrent() {
        let userLocation = _mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location!.coordinate, 2000, 2000)
        
        _mapView.setRegion(region, animated: true)
    }
    
    func addPin(id: String, lat: String, long: String, fullName: String) {
        let location = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
        //let center = location
        //let region = MKCoordinateRegionMake(center, MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        //_mapView.setRegion(region, animated: true)
        
        pointAnnotation = CustomPointAnnotation()
        pointAnnotation?.pinCustomID = id
        pointAnnotation?.pinCustomImageName = "pin"
        pointAnnotation?.coordinate = location
        pointAnnotation?.title = fullName
        pointAnnotation?.subtitle = fullName
        
        pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
        _mapView.addAnnotation((pinAnnotationView?.annotation!)!)
        /*
        for pin in _mapView.annotations {
            if pin.title!! == fullName {
                _mapView.removeAnnotation(pin)
                _mapView.addAnnotation((pinAnnotationView?.annotation!)!)
            } else {
                _mapView.addAnnotation((pinAnnotationView?.annotation!)!)
            }
        }
        */
    }

}

extension MainMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // locationServicesEnabled
        if CLLocationManager.locationServicesEnabled() {
            switch status {
            case .notDetermined:
                // If status has not yet been determied, ask for authorization
                manager.requestWhenInUseAuthorization()
                break
            case .authorizedWhenInUse:
                // If authorized when in use
                manager.startUpdatingLocation()
                break
            case .authorizedAlways:
                // If always authorized
                manager.startUpdatingLocation()
                break
            case .restricted:
                // If restricted by e.g. parental controls. User can't enable Location Services
                break
            case .denied:
                // If user denied your app access to Location Services, but can grant access from Settings.app
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        
        if timer == nil {
            timer = Timer()
            timer?.invalidate() // just in case this button is tapped multiple times
            // start the timer
            timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(sendLocation), userInfo: nil, repeats: true)
        }
 
    }
    
    func sendLocation() {
        MqttModel.sharedInstance.publishLocation(userId: UserModel.facebookIdOfSignedInUser(), lat: String(location?.coordinate.latitude ?? 0), long: String(location?.coordinate.longitude ?? 0), fullName: UserModel.fullNameOfSignedInUser())
    }
}

extension MainMapViewController: MqttModelDelegate {
    func handleMessage(withMessage data: Data, withOnTopic topic: String) {
        let jsonString = String(data: data, encoding: .utf8)!
        if let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                let track = GraphTracking(json: jsonObject!)
                if track?.userId != UserModel.facebookIdOfSignedInUser() {
                    self.addPin(id: (track?.userId)!, lat: (track?.lat)!, long: (track?.long)!, fullName: (track?.fullName)!)
                }
                
            } catch let error as NSError {
                print(error)
            }
        }
    }
}

extension MainMapViewController: MKMapViewDelegate {
    //MARK: - Custom Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let customPointAnnotation = annotation as! CustomPointAnnotation
        annotationView?.image = UIImage(named: "pin")
        
        return annotationView
    }
}
