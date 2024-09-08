// Abstract: methods for loading and saving user data.

import CoreData

extension CoreDataStack {
    /// Saves `User` data recieved from `WebAPICaller` fetch call to `UserEntity` objects in Core Data model.
    func loadUsers() async {
        do {
            let users = try await WebAPICaller.shared.fetchUsers()
            
            try await persistentContainer.performBackgroundTask { context in
                try users.forEach { user in
                    try self.saveUserEntity(for: user, in: context)
                }
                print("Loaded data.")
            }
        } catch {
            fatalError("Failed to load data. Error: \(error.localizedDescription)") // TODO: Handle errors here
        }
    }
    
    /// Saves a single `UserEntity` object in the given context.
    func saveUserEntity(for user: User, in context: NSManagedObjectContext) throws {
        let userEntity = UserEntity(context: context)
        userEntity.id = Int64(user.id)
        userEntity.firstName = user.firstName
        userEntity.lastName = user.lastName
        userEntity.email = user.email
        userEntity.gender = user.gender
        userEntity.avatarURL = user.avatar
        
        do {
            try context.save()
            print("Made user entity record for: \(userEntity.fullName)")
        } catch {
            throw CoreDataError(kind: .userSave, user: userEntity)
        }
    }
}
