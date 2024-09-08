//
//  TabBarViewController.swift
//  MSAppsHomeAssignment
//
//  Created by David Katsman on 08/09/2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        guard let controllers = viewControllers else {
            print("Tab Bar has no view controllers.")
            return
        }
        
        for controller in controllers {
            guard let navigationController = controller as? UINavigationController else {
                print("This controller isn't a UINavigationController.")
                continue
            }
            switch navigationController.topViewController {
            case is UsersListViewController:
                navigationController.setTabBarItem(for: .usersList)
            case is NotesListViewController:
                navigationController.setTabBarItem(for: .notesList)
            default:
                navigationController.setTabBarItem(for: .map)
            }
        }
    }
}
