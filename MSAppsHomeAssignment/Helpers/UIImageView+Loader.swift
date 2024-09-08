// Abstract: extension for efficient image loading for Users list.

import UIKit

extension UIImageView {
    func loadImage(for user: UserEntity) {
        self.image = UIImage(systemName: "person.fill")
        
        if let avatar = user.image, let imageData = avatar.imageData, let image = UIImage(data: imageData) {
            self.image = image
        } else {
            Task(priority: .high) {
                do {
                    let data = try await WebAPICaller.shared.fetchImage(for: user)
                    self.image = UIImage(data: data)
                    try CoreDataStack.shared.saveUserAvatar(for: user, data: data)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
