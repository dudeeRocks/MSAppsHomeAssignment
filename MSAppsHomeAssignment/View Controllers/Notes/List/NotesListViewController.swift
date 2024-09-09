// Abstract: View controller for the list of Notes.

import UIKit
import CoreData

class NotesListViewController: UITableViewController {
    
    var fetchResultsController: NSFetchedResultsController<Note>!
    var emptyStateView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        createFetchResultsController()
        setTabBarItem(for: .notesList)
        setUpEmptyStateView()
        checkIfNotesExist()
        navigationItem.title = "Notes"
        print("notes list did load")
    }

    // MARK: - Table View Overrides

    override func numberOfSections(in tableView: UITableView) -> Int {
        fetchResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = fetchResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableCell

        cell.title.text = note.body
        cell.dateModified.text = note.dateModified?.dayAndTimeText

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? NoteDetailsController, let indexPath = tableView.indexPathForSelectedRow {
            detailsVC.note = fetchResultsController.object(at: indexPath)
        }
    }
}
