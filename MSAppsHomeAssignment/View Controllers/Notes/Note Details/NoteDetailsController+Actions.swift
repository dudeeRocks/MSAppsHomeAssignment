// Abstract: @objc selectors for actions

import UIKit

extension NoteDetailsController {
    @objc func saveExistingNote() {
        
    }
    
    @objc func saveNewNote() {
        updateUI(for: .view)
    }
    
    @objc func cancelAddNote() {
        dismiss(animated: true)
    }
    
    @objc func cancelEditing() {
        updateUI(for: .view)
    }
    
    @objc func deleteNote() {
        shouldDeleteNote = true
        delegate?.didUpdateNote()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func editNote() {
        updateUI(for: .edit)
    }
}
