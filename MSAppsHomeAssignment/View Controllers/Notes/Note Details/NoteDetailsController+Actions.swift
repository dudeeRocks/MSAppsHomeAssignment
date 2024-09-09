// Abstract: @objc selectors for actions

import UIKit

extension NoteDetailsController {
    @objc func autoSaveExistingNote() {
        guard let text = textField.text else {
            return
        }
        
        let location = mapView.centerCoordinate
        
        if note != nil {
            note.body = textField.text
            note.location?.latitude = mapView.centerCoordinate.latitude
            note.location?.longitude = mapView.centerCoordinate.longitude
            note.dateModified = Date.now
            CoreDataStack.shared.saveViewContext()
        }
    }
    
    @objc func saveNewNote() {
        guard let text = textField.text else {
            return
        }
        
        let location = mapView.centerCoordinate
        
        do {
            let newNote = try CoreDataStack.shared.createNote(withText: text, at: location, date: Date.now)
            note = newNote
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
        goBackToNotesList()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
