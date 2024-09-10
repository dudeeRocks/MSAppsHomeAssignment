// Abstract: special map view to show on Note Details screen

import UIKit
import MapKit

class MapContentView: UIView, UIContentView {
    
    let mapView = MKMapView()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    // MARK: - Initializers
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpMap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        mapView.setCenter(configuration.location, animated: true)
    }
    
    func setUpMap() {
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: leftAnchor),
            mapView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    // MARK: - Configuration
    
    struct Configuration: UIContentConfiguration {
        var location: CLLocationCoordinate2D = .init()
        
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
