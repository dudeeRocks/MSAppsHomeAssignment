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
        saveButton.isEnabled = isSaveButtonEnabled
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
            self.autoSaveExistingNote()
        })
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if note == nil {
            navigationItem.rightBarButtonItem = saveButton
            saveButton.isEnabled = isSaveButtonEnabled
        } else {
            navigationItem.rightBarButtonItem = deleteButton
        }
    }
}
