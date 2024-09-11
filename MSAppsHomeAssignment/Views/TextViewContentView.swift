// Abstract: special text view for editing notes

import UIKit

class TextViewContentView: UIView, UIContentView {
    
    let textView = UITextView(frame: .zero)
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    private var textViewHeightConstraint: NSLayoutConstraint!
    
    private var textHeight: CGFloat {
        textView.hasText ? textView.contentSize.height : 100.0
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
        
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: textHeight)
        textViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textView.leftAnchor.constraint(equalTo: leftAnchor),
            textView.rightAnchor.constraint(equalTo: rightAnchor),
            placeholder.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeholder.leftAnchor.constraint(equalTo: textView.leftAnchor, constant: 6),
            placeholder.rightAnchor.constraint(equalTo: textView.rightAnchor)
        ])
    }
    
    // MARK: - Configuration
    
    struct Configuration: UIContentConfiguration {
        var text: String?
        
        func makeContentView() -> any UIView & UIContentView {
            return TextViewContentView(configuration: self)
        }
        
        func updated(for state: any UIConfigurationState) -> TextViewContentView.Configuration {
            return self
        }
    }
}

extension UICollectionViewListCell {
    func textViewConfiguration() -> TextViewContentView.Configuration {
        TextViewContentView.Configuration()
    }
}

extension TextViewContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        textViewHeightConstraint.constant = textView.hasText ? textView.contentSize.height : 100.0
        layoutIfNeeded()
        print("text height = \(textHeight)")
        
        if textView.hasText {
            UIView.transition(with: placeholder, duration: 0.3) {
                self.placeholder.isHidden = true
            }
        } else {
            UIView.transition(with: placeholder, duration: 0.3) {
                self.placeholder.isHidden = false
            }
        }
    }
}
