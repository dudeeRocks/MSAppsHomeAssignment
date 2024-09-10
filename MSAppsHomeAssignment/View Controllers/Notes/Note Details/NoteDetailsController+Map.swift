// Abstract: methods for managing MKMapView

import UIKit
import MapKit

extension NoteDetailsController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func prepareMapView() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if note == nil {
            mapView.showsUserLocation = true
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
            mapView.setUserTrackingMode(.follow, animated: true)
        } else {
            let coordinate = CLLocationCoordinate2D(latitude: note.location!.latitude, longitude: note.location!.longitude)
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = coordinate
            
            mapView.setUserTrackingMode(.none, animated: false)
            mapView.setCenter(coordinate, animated: true)
            mapView.addAnnotation(pointAnnotation)
        }
    }
}
