// Abstract: Extension for UIStoryboard for getting relevant view controllers quickly.

import UIKit

extension UIStoryboard {
    static func getViewController(withIdentifier identifier: ViewControllerID) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let id: String = identifier.identifier
        let viewController: UIViewController = storyboard.instantiateViewController(withIdentifier: id)
        return viewController
    }
}

enum ViewControllerID {
    case main, login, usersList, userDetails, notesList, noteDetails, map
    
    var identifier: String {
        switch self {
        case .main:
            return "Main"
        case .login:
            return "LoginScreen"
        case .usersList:
            return "UsersList"
        case .userDetails:
            return "UserDetails"
        case .notesList:
            return "NotesList"
        case .noteDetails:
            return "NoteDetails"
        case .map:
            return "Map"
        }
    }
}
