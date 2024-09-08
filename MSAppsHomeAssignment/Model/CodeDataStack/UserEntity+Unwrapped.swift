// Abstract: Extension for unwrapping UserEntity's properties

import Foundation

extension UserEntity {
    var unwrappedFirstName: String {
        firstName ?? "First Name"
    }
    
    var unwrappedLastName: String {
        lastName ?? "Last Name"
    }
    
    var fullName: String {
        unwrappedFirstName + " " + unwrappedLastName
    }
}
