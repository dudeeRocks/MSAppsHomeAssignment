// Abstract: @objc selectors for actions

import UIKit
import MapKit

extension NoteDetailsController {
    @objc func saveNewNote() {
        if isNewNote {
            Task { @MainActor in
                do {
                    /// It's safe to force unwrap `newNoteText`here, because the `saveButton` that calls the `saveNewNote()` function only if `isSaveEnabled` is `true`.
                    try await CoreDataStack.shared.createNote(withText: newNoteText!, at: newLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), date: Date.now)
                    delegate?.didUpdateNote()
                    dismiss(animated: true)
                } catch {
                    fatalError("failed to save new note") // TODO: Handle error here.
                }
            }
        } else {
            if let body = newNoteText {
                note.body = body
            }
            if let location = newLocation {
                note.location?.latitude = location.latitude
                note.location?.longitude = location.longitude
            }
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
