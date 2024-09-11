// Abstract: @objc selectors for actions

import UIKit
import MapKit

extension NoteDetailsController {
    @objc func saveNewNote() {
        if isNewNote {
            Task { @MainActor in
                do {
                    try await CoreDataStack.shared.createNote(withText: newNoteText, at: newLocation, date: Date.now)
                    delegate?.didUpdateNote()
                    dismiss(animated: true)
                } catch {
                    fatalError("failed to save new note") // TODO: Handle error here.
                }
            }
        } else {
            note.body = newNoteText
            // TODO: Make sure to set to correct values here
            note.location?.latitude = newLocation.latitude
            note.location?.longitude = newLocation.longitude
            note.dateModified = Date.now
            
            CoreDataStack.shared.saveViewContext()
            delegate?.didUpdateNote()
            updateUI(for: .view)
        }
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
