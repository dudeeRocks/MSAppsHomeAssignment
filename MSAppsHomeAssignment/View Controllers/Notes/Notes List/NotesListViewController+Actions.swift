// Abstract: wrapper for actions on NotesListViewController

import UIKit

extension NotesListViewController {
    @objc func addNote() {
        let navigationVC = UINavigationController(rootViewController: .getViewController(withIdentifier: .noteDetails))
        present(navigationVC, animated: true)
    }
    
    @objc func editNote(at indexPath: IndexPath) {
        guard let note = dataSource.itemIdentifier(for: indexPath) else { return }
        
        if let noteDetailsVC = UIViewController.getViewController(withIdentifier: .noteDetails) as? NoteDetailsController {
            noteDetailsVC.note = note
            navigationController?.pushViewController(noteDetailsVC, animated: true)
        }
    }
    
    func deleteNote(at indexPath: IndexPath) {
        guard let note = dataSource.itemIdentifier(for: indexPath) else { return }
        
        CoreDataStack.shared.viewContext.delete(note)
        CoreDataStack.shared.saveViewContext()
        
        updateSnapshot()
    }
}

enum NoteEditingReason: Sendable {
    case createNewNote, editExistingNote(Note)
}

extension Note: @unchecked Sendable { }
