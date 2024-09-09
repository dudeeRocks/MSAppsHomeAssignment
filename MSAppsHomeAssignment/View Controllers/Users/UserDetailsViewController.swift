//
//  UserDetailsViewController.swift
//  MSAppsHomeAssignment
//
//  Created by David Katsman on 08/09/2024.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    var user: UserEntity?

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var gender: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateUserDetailsView()
    }
    
    private func populateUserDetailsView() {
        guard let user = user else { return }
        
        avatar.loadImage(for: user)
        fullName.text = user.fullName
        email.text = user.email
        gender.text = user.gender
    }
}
