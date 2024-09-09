// Abstract: methods for handling text input

import UIKit

extension NoteDetailsController: UITextFieldDelegate {
    func setTextFieldDelegate() {
        textField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        autoSaveTimer?.invalidate()
        
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
            self.saveNote()
        })
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text?.count == 0 && note == nil {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = deleteButton
        }
    }
}
