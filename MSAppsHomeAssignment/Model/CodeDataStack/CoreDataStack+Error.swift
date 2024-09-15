// Abstact: Custom error type for CoreDataStack.

import CoreData

extension CoreDataStack {
    struct CoreDataError: Error {
        enum ErrorKind {
            case allUsersLoad
            case userSave
            case imageLoad
            case imageSave
            case noteSave
        }
        
        let kind: ErrorKind
        var user: UserEntity?
        var note: Note?
        
        var localizedDescription: String {
            switch self.kind {
            case .allUsersLoad:
                return String(localized: "Failed to load users to persistent storage.")
            case .userSave:
                return String(localized: "Failed to save user: \(userName)")
            case .imageLoad:
                return String(localized: "Failed to load image for user: \(userName)")
            case .imageSave:
                return String(localized: "Failed to save image for user: \(userName)")
            case .noteSave:
                return String(localized: "Failed to save the note.")
            }
        }
        
        private var userName: String {
            guard let user = user else {
                return "NONAME (couldn't get the user name)"
            }
            return user.fullName
        }
    }
}
