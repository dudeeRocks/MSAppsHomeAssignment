// Abstract: wrapper for actions on NotesListViewController

import UIKit

extension NotesListViewController {
    @objc func createNewNote() {
        navigationController?.pushViewController(.getViewController(withIdentifier: .noteDetails), animated: true)
    }
}

enum NoteEditingReason: Sendable {
    case createNewNote, editExistingNote(Note)
}

extension Note: @unchecked Sendable { }
