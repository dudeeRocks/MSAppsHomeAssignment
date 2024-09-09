// Abstract: @objc selectors for actions

import UIKit

extension NoteDetailsController {
    @objc func saveNote() {
        guard let text = textField.text else {
            return
        }
        
        let location = mapView.centerCoordinate
        
        do {
            if note == nil {
                let newNote = try CoreDataStack.shared.createNote(withText: text, at: location, date: Date.now)
                note = newNote
            } else {
                note.body = textField.text
                note.location?.latitude = mapView.centerCoordinate.latitude
                note.location?.longitude = mapView.centerCoordinate.longitude
                note.dateModified = Date.now
                CoreDataStack.shared.saveContext()
            }
        } catch {
            fatalError("Failed to save a note. Error: \(error.localizedDescription)")// TODO: Handle errors here
        }
    }
    
    @objc func deleteNote() {
        shouldDeleteNote = true
        goBackToNotesList()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
