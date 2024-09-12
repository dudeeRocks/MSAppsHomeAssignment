// Abstract: special map view to show on Note Details screen

import UIKit
import MapKit

class MapContentView: UIView, UIContentView {
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    var localSearch: MKLocalSearch? {
        willSet {
            localSearch?.cancel()
        }
    }
    
    // MARK: - Initializers
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpLocationManager()
        setUpMap()
        subscribeToNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(configuration: UIContentConfiguration) {
        setCenterToDefault()
    }
    
    func setUpMap() {
        addSubview(mapView)
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
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
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
                    if let coordinate = response.mapItems.first?.placemark.coordinate {
                        setCenter(to: coordinate)
                        configuration.onLocationUpdate(coordinate)
                    }
                }
            }
        }
    }
    
    func setCenterToDefault() {
        if let configuration = configuration as? Configuration {
            var coordinate = CLLocationCoordinate2D()
            if let location = configuration.location {
                coordinate = location.coordinate
            } else {
                if case .authorizedWhenInUse = locationManager.authorizationStatus {
                    coordinate = mapView.userLocation.coordinate
                } else {
                    coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                }
            }
            
            setCenter(to: coordinate)
        }
    }
    
    func setCenter(to coordinate: CLLocationCoordinate2D) {
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        mapView.setCenter(coordinate, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    // MARK: - Configuration
    
    struct Configuration: UIContentConfiguration {
        var location: NoteLocation? = nil
        var onLocationUpdate: (CLLocationCoordinate2D) -> Void = { _ in }
        
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
        guard let location = locations.last else { return }
        mapView.setCenter(location.coordinate, animated: true)
        
        guard let configuration = configuration as? Configuration else { return }
        configuration.onLocationUpdate(location.coordinate)
    }
}

extension MapContentView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let annotation = MKMarkerAnnotationView(frame: .zero)
        annotation.animatesWhenAdded = true
        annotation.markerTintColor = .systemBlue
        return annotation
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        setCenterToDefault()
    }
}
