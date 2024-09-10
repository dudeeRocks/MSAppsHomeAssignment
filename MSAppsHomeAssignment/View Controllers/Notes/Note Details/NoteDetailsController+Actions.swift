// Abstract: @objc selectors for actions

import UIKit

extension NoteDetailsController {
    @objc func autoSaveExistingNote() {
        guard let text = textView.text else {
            return
        }
        
        let location = mapView.centerCoordinate
        
        if note != nil {
            note.body = textView.text
            note.location?.latitude = mapView.centerCoordinate.latitude
            note.location?.longitude = mapView.centerCoordinate.longitude
            note.dateModified = Date.now
            
            CoreDataStack.shared.saveViewContext()
            
            delegate?.didUpdateNote()
            
            dateLabel.text = "Saved: " + note.dateModified!.dayAndTimeText
        }
    }
    
    @objc func saveNewNote() {
        guard let text = textView.text else {
            return
        }
        
        let location = mapView.centerCoordinate
        
        do {
            let newNote = try CoreDataStack.shared.createNote(withText: text, at: location, date: Date.now)
            note = newNote
            
            delegate?.didUpdateNote()
            
            dismiss(animated: true)
        } catch {
            fatalError("Failed to save new note")
        }
    }
    
    @objc func cancelAddNote() {
        dismiss(animated: true)
    }
    
    @objc func deleteNote() {
        shouldDeleteNote = true
        delegate?.didUpdateNote()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func setSaveButtonState() {
        if textView.hasText {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}
