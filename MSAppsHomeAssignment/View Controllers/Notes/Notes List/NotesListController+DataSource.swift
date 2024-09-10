// Abstract: methods dealing with diffable data source for notes list.

import UIKit
import CoreData

extension NotesListController {
    typealias DataSource = UITableViewDiffableDataSource<Int, Note>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Note>
    
    func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, note in
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
            
            var content = cell.defaultContentConfiguration()
            content.text = note.body
            content.textProperties.font = .preferredFont(forTextStyle: .body)
            content.secondaryText = note.dateModified?.dayAndTimeText
            content.secondaryTextProperties.font = .preferredFont(forTextStyle: .caption1)
            content.secondaryTextProperties.color = .secondaryLabel
            
            cell.contentConfiguration = content
            cell.accessoryType = .disclosureIndicator
            
            return cell
        })
        tableView.dataSource = dataSource
    }
    
    func updateNotesList() {
        fetchNotes()
        applySnapshot()
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(notes)
        if !notes.isEmpty {
            snapshot.reloadItems(notes)
        }
        dataSource.apply(snapshot)
    }
    
    private func fetchNotes() {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Note.dateModified, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            notes = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
        } catch {
            fatalError("Failed to perform fetch: \(error.localizedDescription)")
        }
    }
}
