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
        setUpSearchCompleter()
        subscribeToNotifications()
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
        textField.placeholder = "Search for a location"
        textField.background = nil
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            textField.rightAnchor.constraint(equalTo: rightAnchor),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func setUpSearchCompleter() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter.delegate = self
        searchCompleter.region = MKCoordinateRegion(.world)
        searchCompleter.resultTypes = .address
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextField), name: .didTapSearchResult, object: nil)
    }
    
    @objc func updateTextField(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let searchCompletion = userInfo[NSNotification.searchCompletionKey] as? MKLocalSearchCompletion {
                endEditing(true)
                textField.text = searchCompletion.title
            }
        }
    }
    
    // MARK: - Configuration
    
    struct Configuration: UIContentConfiguration {
        var text: String? = nil
        var onResultsUpdate: ([MKLocalSearchCompletion]) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return LocationSearchFieldContentView(configuration: self)
        }
        
        func updated(for state: any UIConfigurationState) -> LocationSearchFieldContentView.Configuration {
            return self
        }
    }
}

extension UICollectionViewListCell {
    func locationSearchFieldConfiguration() -> LocationSearchFieldContentView.Configuration {
        LocationSearchFieldContentView.Configuration()
    }
}

// MARK: - UITextFieldDelegate

extension LocationSearchFieldContentView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            searchCompleter.queryFragment = text
        }
        return true
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationSearchFieldContentView: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        guard let configuration = configuration as? Configuration else { return }
        configuration.onResultsUpdate(completer.results)
    }
}
