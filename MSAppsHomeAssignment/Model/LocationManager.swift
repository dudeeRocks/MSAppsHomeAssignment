// Abstract: single point of access to CLLocationManager.

import MapKit

class LocationManager {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    var authorizationStatus: CLAuthorizationStatus { locationManager.authorizationStatus }
    
    func setUpLocationManager(on delegate: CLLocationManagerDelegate) {
        locationManager.delegate = delegate
        locationManager.requestWhenInUseAuthorization()
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func getUserLocationCoordinate() -> CLLocationCoordinate2D? {
        locationManager.startUpdatingLocation()
        return locationManager.location?.coordinate
    }
    
    private init() {
        
    }
}
