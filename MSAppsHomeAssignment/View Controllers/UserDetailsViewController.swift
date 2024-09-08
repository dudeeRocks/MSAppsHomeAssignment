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
        
        avatar.image = UIImage(systemName: "person.fill") // TODO: Display relevant avatar
        fullName.text = user.fullName
        email.text = user.email
        gender.text = user.gender
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
