// Abstract: view controller that manages users list

import UIKit
import CoreData

class UsersListViewController: UITableViewController {
    
    var fetchResultsController: NSFetchedResultsController<UserEntity>!

    override func viewDidLoad() {
        super.viewDidLoad()
        createFetchResultsController()
        setUpNavigationItem()
        setTabBarItem(for: .usersList)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        fetchResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = fetchResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableCell
        
        cell.userNameLabel.text = user.fullName
        cell.avatarView.loadImage(for: user)

        return cell
    }

    // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? UserDetailsViewController, let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.user = fetchResultsController.object(at: indexPath)
        }
    }
    
    private func setUpNavigationItem() {
        let rightButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.title = "Users"
    }
    
    @objc private func logOut() {
        AuthManager.isLoggedIn = false
        
        let loginViewController = UIStoryboard.getViewController(withIdentifier: .login)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: {$0 is UIWindowScene}) as? UIWindowScene else {
            fatalError("No UIWindowScene")
        }
        
        guard let window = windowScene.windows.first else {
            fatalError("no window found")
        }
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            window.rootViewController = loginViewController
        })
    }
}
