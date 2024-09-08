// Abstract: UIViewController extensions that help with common setup.

import UIKit

extension UIViewController {
    func setTabBarItem(for identifier: ViewControllerID) {
        let title: String
        let unselectedImageName: String
        let selectedImageName: String
        
        switch identifier {
        case .usersList:
            title = "Users"
            unselectedImageName = "person.3"
            selectedImageName = "person.3.fill"
        case .notesList:
            title = "Notes"
            unselectedImageName = "note.text"
            selectedImageName = "note.text"
        case .map:
            title = "Map"
            unselectedImageName = "map"
            selectedImageName = "map.fill"
        default:
            return
        }
        
        tabBarItem.title = title
        
        if let image = UIImage(systemName: unselectedImageName) {
            tabBarItem.image = image
        }
        
        if let selectedImage = UIImage(systemName: selectedImageName) {
            tabBarItem.selectedImage = selectedImage
        }
    }
    
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
