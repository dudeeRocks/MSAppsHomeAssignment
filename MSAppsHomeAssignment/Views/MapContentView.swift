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
    
    // MARK: - Initializers
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpLocationManager()
        setUpMap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        if let location = configuration.location {
            mapView.setCenter(location.coordinate, animated: true)
        } else {
            if case .authorizedWhenInUse = locationManager.authorizationStatus {
                mapView.setCenter((mapView.userLocation.coordinate), animated: true)
            } else {
                mapView.setCenter(CLLocationCoordinate2D(latitude: 0, longitude: 0), animated: false)
            }
        }
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
    
}
