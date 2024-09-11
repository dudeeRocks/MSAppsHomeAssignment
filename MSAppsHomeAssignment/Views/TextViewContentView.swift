// Abstract: special text view for editing notes

import UIKit

class TextViewContentView: UIView, UIContentView {
    
    let textView = UITextView(frame: .zero)
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    private let placeholder: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("Start typing your thoughts here...", comment: "Note text field placeholder text.")
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .placeholderText
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textView.text = configuration.text
        placeholder.isHidden = configuration.text != nil
    }
    
    func setUpTextView() {
        addSubview(textView)
        addSubview(placeholder)
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textAlignment = .left
        textView.backgroundColor = nil
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textView.leftAnchor.constraint(equalTo: leftAnchor),
            textView.rightAnchor.constraint(equalTo: rightAnchor),
            textView.heightAnchor.constraint(equalToConstant: 200),
            placeholder.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeholder.leftAnchor.constraint(equalTo: textView.leftAnchor, constant: 6),
            placeholder.rightAnchor.constraint(equalTo: textView.rightAnchor)
        ])
    }
    
    // MARK: - Configuration
    
    struct Configuration: UIContentConfiguration {
        var text: String?
        var onChange: (String) -> Void = { _ in }
        
        func makeContentView() -> any UIView & UIContentView {
            return TextViewContentView(configuration: self)
        }
        
        func updated(for state: any UIConfigurationState) -> TextViewContentView.Configuration {
            return self
        }
    }
}

extension TextViewContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.hasText {
            UIView.transition(with: placeholder, duration: 0.3) {
                self.placeholder.isHidden = true
            }
        } else {
            UIView.transition(with: placeholder, duration: 0.3) {
                self.placeholder.isHidden = false
            }
        }
        guard let config = configuration as? TextViewContentView.Configuration else { return }
        config.onChange(textView.text)
    }
}

extension UICollectionViewListCell {
    func textViewConfiguration() -> TextViewContentView.Configuration {
        TextViewContentView.Configuration()
    }
}
