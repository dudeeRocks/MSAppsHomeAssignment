// Abstract: location search field

import UIKit
import MapKit

class LocationSearchFieldContentView: UIView, UIContentView {
    
    let textField = UITextField(frame: .zero)
    var configuration: any UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    private var lastChangeTime: TimeInterval = 0
    private var searchCompleter: MKLocalSearchCompleter!
    
    // MARK: - Initializers
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textField.text = configuration.text
    }
    
    func setUpTextField() {
        addSubview(textField)
        textField.textAlignment = .left
        textField.textContentType = .streetAddressLine1
        textField.clearButtonMode = .unlessEditing
        textField.returnKeyType = .search
        textField.placeholder = NSLocalizedString("Search for a location", comment: "Location search field placeholder.")
        textField.background = nil
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leftAnchor.constraint(equalTo: leftAnchor),
            textField.rightAnchor.constraint(equalTo: rightAnchor),
            textField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0)
        ])
    }
    
    func setUpSearchCompleter() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter.delegate = self
        searchCompleter.region = MKCoordinateRegion(.world)
    }
    
    func searchFor(_ string: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = string
        searchRequest.region = MKCoordinateRegion(.world)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let config = self.configuration as? LocationSearchFieldContentView.Configuration else { return }
            config.onChange(response, error)
        }
        
    }
    
    // MARK: - Configuration
    
    struct Configuration: UIContentConfiguration {
        var text: String? = nil
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        var onChange: MKLocalSearch.CompletionHandler = { _, _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return LocationSearchFieldContentView(configuration: self)
        }
        
        func updated(for state: any UIConfigurationState) -> LocationSearchFieldContentView.Configuration {
            return self
        }
    }
}

extension LocationSearchFieldContentView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            searchCompleter.queryFragment = text
        }
        return true
    }
}

extension LocationSearchFieldContentView: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completer.results
    }
}

extension UICollectionViewListCell {
    func locationSearchFieldConfiguration() -> LocationSearchFieldContentView.Configuration {
        LocationSearchFieldContentView.Configuration()
    }
}
