// Abstract: Singleton object to manage Core Data stack.

import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print(#function)
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        print(#function)
    }
    
    // MARK: - Methods
    
    func loadData() async {
        do {
            let users = try await UsersFetcher.shared.fetchUsers()
            
            try await persistentContainer.performBackgroundTask { context in
                try users.forEach { user in
                    try self.makeUserEntityRecord(for: user, in: context)
                }
                print("Loaded data.")
            }
        } catch {
            fatalError("Failed to load data.")
        }
    }
    
    func makeUserEntityRecord(for user: User, in context: NSManagedObjectContext) throws {
        let userEntity = UserEntity(context: context)
        userEntity.id = Int64(user.id)
        userEntity.firstName = user.firstName
        userEntity.lastName = user.lastName
        userEntity.email = user.email
        userEntity.gender = user.gender
        userEntity.avatar = user.avatar
        
        try context.save()
        print("Made user entity record for: \(userEntity.fullName)")
    }
    
    // MARK: - Initializers
    
    private init() { }
}
