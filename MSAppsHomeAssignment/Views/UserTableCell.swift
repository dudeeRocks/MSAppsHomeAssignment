// Abstract: custom desing for user table cells

import UIKit

class UserTableCell: UITableViewCell {
    @IBOutlet private weak var avatarView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    
    var avatar: UIImage? {
        get {
            avatarView.image
        }
        set {
            avatarView.image = newValue
        }
    }
    
    var userName: String {
        get {
            userNameLabel.text ?? "User name"
        }
        set {
            userNameLabel.text = newValue
        }
    }
}
