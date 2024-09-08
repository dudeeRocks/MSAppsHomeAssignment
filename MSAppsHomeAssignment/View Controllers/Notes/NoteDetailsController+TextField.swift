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
        print(#function)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        navigationItem.rightBarButtonItem = nil
    }
}
