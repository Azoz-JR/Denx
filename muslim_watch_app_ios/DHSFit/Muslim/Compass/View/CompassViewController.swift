//
//  CompassViewController.swift
//  MuslimFit
//
//  Created by Karim on 13/07/2023.
//

import UIKit
import CoreLocation

class CompassViewController: UIViewController {
    
    lazy var containerView: CompassContainerView = {
        let view = CompassContainerView(view: self)
        return view
    }()
    
    var localTimeZoneIdentifier: String {
        return TimeZone.current.identifier
    }
    
    //    var compassManager  : CompassDirectionManager!
    
    let locationDelegate = LocationDelegate()
    var latestLocation: CLLocation? = nil
    var yourLocationBearing: CGFloat { return latestLocation?.bearingToLocationRadian(self.yourLocation) ?? 0 }
    var yourLocation: CLLocation {
        get { return UserDefaults.standard.currentLocation }
        set { UserDefaults.standard.currentLocation = newValue }
    }
    
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization()
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.startUpdatingLocation()
        $0.startUpdatingHeading()
        return $0
    }(CLLocationManager())
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        // Do any additional setup after loading the view.
    //        self.navigationController?.isNavigationBarHidden = true
    ////        compassManager =  CompassDirectionManager(dialerImageView: containerView.ivCompassBack, pointerImageView: containerView.ivCompassNeedle)
    ////        compassManager.initManager()
    //
    //    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        locationManager.delegate = locationDelegate
        var qiblaAngle : CGFloat = 0.0
        
//        self.containerView.areaLabel.text = localTimeZoneIdentifier.components(separatedBy: "/").last
        
        locationDelegate.errorCallback = { error in
            self.containerView.angleLabel.text = error
            //          self.imageView.isHidden = true
            print(error)
        }
        
        locationDelegate.locationCallback = { [weak self] location in
            guard let self = self else { return }
//            print("location:", location.coordinate)
            get_locationAddress(location: location.coordinate)
            latestLocation = location
            
            let phiK = 21.4*CGFloat.pi/180.0
            let lambdaK = 39.8*CGFloat.pi/180.0
            let phi = CGFloat(location.coordinate.latitude) * CGFloat.pi/180.0
            let lambda =  CGFloat(location.coordinate.longitude) * CGFloat.pi/180.0
            qiblaAngle = 180.0/CGFloat.pi * atan2(sin(lambdaK-lambda),cos(phi)*tan(phiK)-sin(phi)*cos(lambdaK-lambda))
            
            
//            let ddd = Int(atan2(sin(lambdaK-lambda),cos(phi)*tan(phiK)-sin(phi)*cos(lambdaK-lambda)))
            
            //            self.containerView.angleLabel.text = "\(Int(qiblaAngle.rounded()) - ddd)°"
            
            //            self.imageView.isHidden = false
        }
        
        //      locationDelegate.locationCallback = { location in
        //          self.latestLocation = location
        //
        //          let phiK = 21.4*CGFloat.pi/180.0
        //          let lambdaK = 39.8*CGFloat.pi/180.0
        //          let phi = CGFloat(location.coordinate.latitude) * CGFloat.pi/180.0
        //          let lambda =  CGFloat(location.coordinate.longitude) * CGFloat.pi/180.0
        //          qiblaAngle = 180.0/CGFloat.pi * atan2(sin(lambdaK-lambda),cos(phi)*tan(phiK)-sin(phi)*cos(lambdaK-lambda))
        //          self.containerView.angleLabel.text = "\(Int(qiblaAngle.rounded()))°"
        //
        //          self.imageView.isHidden = false
        //      }
        
        locationDelegate.headingCallback = { newHeading in
            
            func computeNewAngle(with newAngle: CGFloat) -> CGFloat {
                let heading = self.yourLocationBearing - newAngle.degreesToRadians
                return CGFloat(heading)
            }
            
            if Int(qiblaAngle.rounded()) - Int(newHeading) == 0 {
//                self.containerView.ivCompassBack.backgroundColor = .yellow
                self.containerView.angleLabel.isHidden = true
                self.containerView.kaabaStack.isHidden = false
            } else {
//                self.containerView.ivCompassBack.backgroundColor = .clear
                self.containerView.angleLabel.isHidden = false
                self.containerView.kaabaStack.isHidden = false
            }
            
            self.containerView.angleLabel.text = "\(Int(qiblaAngle.rounded()) - Int(newHeading))°"
            
//            UIView.animate(withDuration: 0.5) {
                let angle = (CGFloat.pi/180 * -(CGFloat(newHeading) - qiblaAngle))
                self.containerView.ivCompassBack.transform = CGAffineTransform(rotationAngle: angle)
                self.containerView.compassBack.transform = CGAffineTransform(rotationAngle: CGFloat(newHeading))
//            }
        }
        
    }
    
    override func loadView() {
        super.loadView()
        self.view = containerView
    }
    
    func get_locationAddress(location:CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        let addressLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geoCoder.reverseGeocodeLocation(addressLocation, preferredLocale: NSLocale(localeIdentifier: LanguageManager.shareInstance().getHttpLanguageType()) as Locale, completionHandler: { (placemarks, error) -> Void in
            
            if let placeMark = placemarks?[0]{
                
                let City = placeMark.locality ?? ""
                
//                self.mapAddress = "\(Location_name) \(Street)\(State) \(Zip)\(City)\(Country)"
//                userDefaults.set(self.mapAddress, forKey: "mapAddress")
                self.containerView.areaLabel.text = City
            }
            
        })
    }
}

//import CoreLocation
//
//func degreesToRadians(_ degrees: CLLocationDegrees) -> Double {
//    return degrees * .pi / 180.0
//}
//
//func radiansToDegrees(_ radians: Double) -> CLLocationDegrees {
//    return radians * 180.0 / .pi
//}
//
//func calculateQiblaDirection(userLatitude: Double, userLongitude: Double) -> Double {
//    let kaabaLatitude = 21.4225 // Latitude of Kaaba in Mecca
//    let kaabaLongitude = 39.8262 // Longitude of Kaaba in Mecca
//
//    let userLatRad = degreesToRadians(userLatitude)
//    let userLonRad = degreesToRadians(userLongitude)
//    let kaabaLatRad = degreesToRadians(kaabaLatitude)
//    let kaabaLonRad = degreesToRadians(kaabaLongitude)
//
//    let lonDiff = kaabaLonRad - userLonRad
//
//    let y = sin(lonDiff) * cos(kaabaLatRad)
//    let x = cos(userLatRad) * sin(kaabaLatRad) - sin(userLatRad) * cos(kaabaLatRad) * cos(lonDiff)
//
//    let qiblaDirectionRad = atan2(y, x)
//    let qiblaDirectionDeg = radiansToDegrees(qiblaDirectionRad)
//
//    return qiblaDirectionDeg
//}
//
// Example usage:
//let userLatitude = 37.7749 // Replace with user's latitude
//let userLongitude = -122.4194 // Replace with user's longitude
//
//let qiblaDirection = calculateQiblaDirection(userLatitude: userLatitude, userLongitude: userLongitude)
//print("Qibla direction: \(qiblaDirection) degrees")

extension UserDefaults {
    var currentLocation: CLLocation {
        get { return CLLocation(latitude: latitude ?? 90, longitude: longitude ?? 0) } // default value is North Pole (lat: 90, long: 0)
        set { latitude = newValue.coordinate.latitude
            longitude = newValue.coordinate.longitude }
    }
    
    private var latitude: Double? {
        get {
            if let _ = object(forKey: #function) {
                return double(forKey: #function)
            }
            return nil
        }
        set { set(newValue, forKey: #function) }
    }
    
    private var longitude: Double? {
        get {
            if let _ = object(forKey: #function) {
                return double(forKey: #function)
            }
            return nil
        }
        set { set(newValue, forKey: #function) }
    }
}

class LocationDelegate: NSObject, CLLocationManagerDelegate {
    var locationCallback: ((CLLocation) -> ())? = nil
    var headingCallback: ((CLLocationDirection) -> ())? = nil
    var errorCallback: ((String) -> ())? = nil
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        locationCallback?(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        print("trueHeading \(newHeading.trueHeading) magneticHeading \(newHeading.magneticHeading)")
        headingCallback?(newHeading.trueHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️ Error while updating location " + error.localizedDescription)
        errorCallback?("⚠️ Please enable Location!")
    }
}

public extension CLLocation {
    func bearingToLocationRadian(_ destinationLocation: CLLocation) -> CGFloat {
        
        let lat1 = self.coordinate.latitude.degreesToRadians
        let lon1 = self.coordinate.longitude.degreesToRadians
        
        let lat2 = destinationLocation.coordinate.latitude.degreesToRadians
        let lon2 = destinationLocation.coordinate.longitude.degreesToRadians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return CGFloat(radiansBearing)
    }
    
    func bearingToLocationDegrees(destinationLocation: CLLocation) -> CGFloat {
        return bearingToLocationRadian(destinationLocation).radiansToDegrees
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}

private extension Double {
    var degreesToRadians: Double { return Double(CGFloat(self).degreesToRadians) }
    var radiansToDegrees: Double { return Double(CGFloat(self).radiansToDegrees) }
}
