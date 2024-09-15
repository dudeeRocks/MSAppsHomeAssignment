// Abstract: special map view to show on Note Details screen

import UIKit
import MapKit

class MapContentView: UIView, UIContentView {
    
    typealias LocationUpdateHandler = (_ coordinate: CLLocationCoordinate2D, _ displayName: String) -> Void
    
    let mapView = MKMapView()
    var configuration: UIContentConfiguration
    var localSearch: MKLocalSearch? {
        willSet {
            localSearch?.cancel()
        }
    }
    
    private let defaultLocationName: String = "Unknown location"
    
    // MARK: - Initializers
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpLocationManager()
        setUpMap()
        setCenterToDefault()
        subscribeToNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setUpMap() {
        addSubview(mapView)
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 10_000), animated: false)
        mapView.isUserInteractionEnabled = false
        mapView.showsUserLocation = false
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: leftAnchor),
            mapView.rightAnchor.constraint(equalTo: rightAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func setUpLocationManager() {
        LocationManager.shared.setUpLocationManager(on: self)
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateMap), name: .didTapSearchResult, object: nil)
    }
    
    @objc func updateMap(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let searchCompletion = userInfo[NSNotification.searchCompletionKey] as? MKLocalSearchCompletion {
                let searchRequest = MKLocalSearch.Request(completion: searchCompletion)
                localSearch = MKLocalSearch(request: searchRequest)
                localSearch?.start { [weak self] response, error in
                    guard
                        let self = self,
                        let response = response,
                        let configuration = configuration as? Configuration,
                        error == nil
                    else {
                        fatalError("search failed") // TODO: handle error here
                    }
                    if let placemark = response.mapItems.first?.placemark {
                        let coordintate = placemark.coordinate
                        let displayName = getAddressDescription(placemark: placemark)
                        
                        setCenter(to: coordintate)
                        configuration.onLocationUpdate(coordintate, displayName)
                    }
                }
            }
        }
    }
    
    func setCenterToDefault() {
        guard let configuration = configuration as? Configuration else { return }
        
        var coordinate = CLLocationCoordinate2D()
        
        if let location = configuration.location {
            coordinate = location.coordinate
        } else {
            switch LocationManager.shared.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                if let userCoordinate = LocationManager.shared.getUserLocationCoordinate() {
                    coordinate = userCoordinate
                    getLocationName(for: userCoordinate, completionHandler: configuration.onLocationUpdate)
                } else {
                    fallthrough
                }
            default:
                mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 10_000), animated: false)
                coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                configuration.onLocationUpdate(coordinate, defaultLocationName)
            }
        }
        
        setCenter(to: coordinate)
    }
    
    func setCenter(to coordinate: CLLocationCoordinate2D) {
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        mapView.setCenter(coordinate, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    func getLocationName(for coordinate: CLLocationCoordinate2D, completionHandler: @escaping LocationUpdateHandler) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard
                let self = self,
                let placemark = placemarks?.first,
                error == nil
            else {
                completionHandler(coordinate, "Unknown location")
                return
            }
            let locationName = getAddressDescription(placemark: placemark)
            completionHandler(coordinate, locationName)
        }
    }
    
    private func getAddressDescription(placemark: CLPlacemark) -> String {
        if let streetAddress = placemark.thoroughfare {
            return streetAddress
        } else if let locality = placemark.locality {
            return locality
        } else if let inLandWater = placemark.inlandWater {
            return inLandWater
        } else if let ocean = placemark.ocean {
            return ocean
        } else {
            return defaultLocationName
        }
    }
    
    // MARK: - Configuration
    
    struct Configuration: UIContentConfiguration {
        var location: NoteLocation? = nil
        var onLocationUpdate: LocationUpdateHandler = { _, _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return MapContentView(configuration: self)
        }
        
        func updated(for state: any UIConfigurationState) -> MapContentView.Configuration {
            return self
        }
    }
}

extension UICollectionViewListCell {
    func mapConfiguration() -> MapContentView.Configuration {
        MapContentView.Configuration()
    }
}

extension MapContentView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
}

extension MapContentView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let annotation = MKMarkerAnnotationView(frame: .zero)
        annotation.animatesWhenAdded = true
        annotation.markerTintColor = .systemBlue
        return annotation
    }
}
