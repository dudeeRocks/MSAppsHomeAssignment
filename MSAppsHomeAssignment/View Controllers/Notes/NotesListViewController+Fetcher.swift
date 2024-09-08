// Abstract: extension for notes list controller to set up fetch results controller

import UIKit
import CoreData

extension NotesListViewController: NSFetchedResultsControllerDelegate {
    func createFetchResultsController() {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateModified", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultsController.delegate = self
        
        do {
            try fetchResultsController.performFetch()
        } catch {
            fatalError("Failed to perform fetch: \(error.localizedDescription)")
        }
    }
}
