// Abstract: methods that handle updates to list from NoteDetails screen.

import UIKit

extension NotesListController: NoteDetailsDelegate {
    func didUpdateNote() {
        updateNotesList()
        checkIfNotesExist()
    }
}
