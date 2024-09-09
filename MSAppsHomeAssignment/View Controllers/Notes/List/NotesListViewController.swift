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
        navigationItem.title = "Notes"
        print("notes list did load")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? NoteDetailsController, let indexPath = tableView.indexPathForSelectedRow {
            detailsVC.note = dataSource.itemIdentifier(for: indexPath)
        }
    }
}
