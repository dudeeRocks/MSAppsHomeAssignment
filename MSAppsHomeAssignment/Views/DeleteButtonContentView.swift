// Abstract: delete button for edit note view

import UIKit

class DeleteButtonContentView: UIView, UIContentView {
    
    let deleteButton = UIButton(frame: .zero)
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    // MARK: - Initializer
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpDeleteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        let action = UIAction { _ in
            configuration.onTap()
        }
        deleteButton.setTitle(configuration.text, for: .normal)
        deleteButton.addAction(action, for: .touchUpInside)
    }
    
    func setUpDeleteButton() {
        addSubview(deleteButton)
        deleteButton.role = .destructive
        deleteButton.tintColor = .systemRed
        deleteButton.configuration = .borderless()
        deleteButton.configuration?.buttonSize = .large
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0)
        ])
    }
    
    // MARK: - Configuration
    
    struct Configuration: UIContentConfiguration {
        var text: String = ""
        var onTap: () -> Void = {}
        
        func makeContentView() -> any UIView & UIContentView {
            return DeleteButtonContentView(configuration: self)
        }
        
        func updated(for state: any UIConfigurationState) -> DeleteButtonContentView.Configuration {
            return self
        }
    }
}

extension UICollectionViewListCell {
    func deleteButtonConfiguration() -> DeleteButtonContentView.Configuration {
        DeleteButtonContentView.Configuration()
    }
}
