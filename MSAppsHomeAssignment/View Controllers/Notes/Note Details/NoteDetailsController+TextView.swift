// Abstract: methods for handling text input

import UIKit

extension NoteDetailsController: UITextViewDelegate {
    
    var textHeight: CGFloat {
        textView.hasText ? textView.contentSize.height : 30.0
    }
    
    func prepareTextView() {
        textView.delegate = self
        textView.isEditable = true
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainer.lineFragmentPadding = .zero
        textView.textContainerInset.top = .zero
        
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: textHeight)
        textViewHeightConstraint?.isActive = true
        
        textView.addSubview(textViewPlaceholder)
        
        NSLayoutConstraint.activate([
            textViewPlaceholder.topAnchor.constraint(equalTo: textView.topAnchor),
            textViewPlaceholder.widthAnchor.constraint(equalTo: textView.widthAnchor, multiplier: 1.0)
        ])
        
        updatePlaceholder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        print("text height: \(textHeight)")
        textViewHeightConstraint?.constant = textHeight
        view.layoutIfNeeded()
        
        autoSaveTimer?.invalidate()
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
            self.autoSaveExistingNote()
        })
        
        updatePlaceholder()
        updateSaveButtonState()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updatePlaceholder()
        updateSaveButtonState()
    }
    
    func updatePlaceholder() {
        if textView.hasText {
            textViewPlaceholder.isHidden = true
        } else {
            textViewPlaceholder.isHidden = false
        }
    }
    
    func updateSaveButtonState() {
        guard note == nil else { return }
        saveButton.isEnabled = textView.hasText
    }
}
