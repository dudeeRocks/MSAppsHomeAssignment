// Abstract: extension for displaying empty state on empty notes list.

import UIKit

extension NotesListViewController {
    func setUpEmptyStateView() {
        let nib = UINib(nibName: "NotesEmptyState", bundle: nil)
        emptyStateView = nib.instantiate(withOwner: nil).first as! NotesEmptyState
    }
    
    func checkIfNotesExist() {
        let fetchRequest = Note.fetchRequest()
        let context = CoreDataStack.shared.persistentContainer.viewContext
        do {
            let notesCount = try context.count(for: fetchRequest)
            
            if notesCount == 0 {
                showEmptyState()
            } else {
                hideEmptyState()
            }
        } catch {
            print("Failed to count notes.")
        }
    }
    
    private func showEmptyState() {
        if let emptyView = emptyStateView {
            tableView.backgroundView = emptyView
        }
    }
    
    private func hideEmptyState() {
        tableView.backgroundView = nil
    }
}
