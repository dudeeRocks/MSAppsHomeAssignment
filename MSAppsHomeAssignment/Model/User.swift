// Abstract: An object that represents a user.

import Foundation

struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let gender: String
    let avatar: String
}
