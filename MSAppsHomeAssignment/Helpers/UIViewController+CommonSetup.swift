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
            unselectedImageName = "person.3.fill"
            selectedImageName = "person.3"
        case .notesList:
            title = "Notes"
            unselectedImageName = "note.text"
            selectedImageName = "note.text"
        case .map:
            title = "Map"
            unselectedImageName = "map.fill"
            selectedImageName = "map"
        default:
            return
        }
        
        navigationController?.tabBarItem.title = title
        
        if let image = UIImage(systemName: unselectedImageName) {
            navigationController?.tabBarItem.image = image
        }
        
        if let selectedImage = UIImage(systemName: selectedImageName) {
            navigationController?.tabBarItem.selectedImage = selectedImage
        }
    }
}
