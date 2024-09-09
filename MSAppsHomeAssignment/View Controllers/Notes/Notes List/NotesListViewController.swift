// Abstract: View controller for the list of Notes.

import UIKit
import CoreData

class NotesListViewController: UITableViewController {
    
    var dataSource: DataSource!
    var notes: [Note] = []
    var emptyStateView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfNotesExist()
        print("Notes list will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchNotes()
        updateSnapshot(reloading: notes)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotes()
        configureDataSource()
        updateSnapshot(reloading: notes)
        setTabBarItem(for: .notesList)
        setUpEmptyStateView()
        checkIfNotesExist()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        navigationItem.title = "Notes"
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? NoteDetailsController, let indexPath = tableView.indexPathForSelectedRow {
            detailsVC.note = dataSource.itemIdentifier(for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if case .delete = editingStyle {
            deleteNote(at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let config = UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .destructive, title: "Delete", handler: { _, _, completion in
                self.deleteNote(at: indexPath)
                completion(false)
            })
        ])
        return config
    }
}
