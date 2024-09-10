// Abstract: methods for handling text input

import UIKit

extension NoteDetailsController: UITextViewDelegate {
    
    var textHeight: CGFloat {
        textView.hasText ? textView.contentSize.height : 40.0
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
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        textViewHeightConstraint?.constant = textHeight
        view.layoutIfNeeded()
        
        autoSaveTimer?.invalidate()
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
            self.autoSaveExistingNote()
        })
        
        updatePlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if note == nil {
            navigationItem.rightBarButtonItem = saveButton
            setSaveButtonState()
        } else {
            navigationItem.rightBarButtonItem = deleteButton
        }
        
        updatePlaceholder()
    }
    
    func updatePlaceholder() {
        if textView.hasText {
            textViewPlaceholder.isHidden = true
        } else {
            textViewPlaceholder.isHidden = false
        }
    }
}
