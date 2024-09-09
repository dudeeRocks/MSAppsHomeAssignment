// Abstract: methods dealing with diffable data source for notes list.

import UIKit
import CoreData

extension NotesListViewController {
    typealias DataSource = UITableViewDiffableDataSource<Int, Note>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Note>
    
    func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, note in
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableCell
            cell.title.text = note.body
            cell.dateModified.text = note.dateModified?.dayAndTimeText
            return cell
        })
    }
    
    func updateSnapshot(reloading notes: [Note] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(notes)
        if !notes.isEmpty {
            snapshot.reloadItems(notes)
        }
        dataSource.apply(snapshot)
    }
    
    func fetchNotes() {
        fetchNotesFromCoreData()
        updateSnapshot()
    }
    
    func fetchNotesFromCoreData() {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateModified", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            notes = try context.fetch(fetchRequest)
        } catch {
            fatalError("Failed to perform fetch: \(error.localizedDescription)")
        }
    }
}
