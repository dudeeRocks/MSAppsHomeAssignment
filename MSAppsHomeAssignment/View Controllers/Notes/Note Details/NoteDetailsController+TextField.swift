// Abstract: methods for handling text input

import UIKit

extension NoteDetailsController: UITextFieldDelegate {
    func prepareTextField() {
        textField.delegate = self
        textField
        if note == nil {
            textField.addTarget(self, action: #selector(setSaveButtonState), for: .editingChanged)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        autoSaveTimer?.invalidate()
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
            self.autoSaveExistingNote()
        })
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if note == nil {
            navigationItem.rightBarButtonItem = saveButton
        } else {
            navigationItem.rightBarButtonItem = deleteButton
        }
    }
}
