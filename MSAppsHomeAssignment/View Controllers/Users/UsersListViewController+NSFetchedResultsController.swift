// Abstract: Extension for UsersListViewController to conform to NSFetchedResultsControllerDelegate

import CoreData

extension UsersListViewController: NSFetchedResultsControllerDelegate {
    func createFetchResultsController() {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
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
