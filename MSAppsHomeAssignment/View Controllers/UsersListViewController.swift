//
//  UsersTableViewController.swift
//  MSAppsHomeAssignment
//
//  Created by David Katsman on 06/09/2024.
//

import UIKit
import CoreData

class UsersListViewController: UITableViewController {
    
    var fetchResultsController: NSFetchedResultsController<UserEntity>!

    override func viewDidLoad() {
        super.viewDidLoad()
        createFetchResultsController()
        setUpNavigationItem()
        setTabBarItem(for: .usersList)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        cell.userName = user.fullName
        cell.avatar = UIImage(systemName: "person.fill")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = fetchResultsController.object(at: indexPath)
        // TODO: transition to selected user details screen
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func setUpNavigationItem() {
        let rightButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
        navigationItem.rightBarButtonItem = rightButton
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
