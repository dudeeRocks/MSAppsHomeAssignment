// Abstract: methods for loading user avatar images

import CoreData

extension CoreDataStack {
    /// Creates `UserAvatar` entity based on the passed image `Data` and saves it to the `image` attribute of the`UserEntity`.
    func saveUserAvatar(for user: UserEntity, data: Data) throws {
        let context = persistentContainer.viewContext
        let avatarEntity = UserAvatar(context: context)
        
        avatarEntity.url = user.avatarURL
        avatarEntity.imageData = data
        avatarEntity.user = user
        user.image = avatarEntity
        
        do {
            try context.save()
            print("Saved user avatar for: \(user.fullName)")
        } catch {
            throw CoreDataError(kind: .imageSave, user: user)
        }
    }
}
