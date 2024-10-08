//
//  AppDelegate.swift
//  MSAppsHomeAssignment
//
//  Created by David Katsman on 05/09/2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        loadData()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        print(#function)
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        print(#function)
    }
}

enum UserDefaultsKeys: String {
    case userName, password, isLoggedIn, hasLoadedData
}

extension AppDelegate {
    var hasLoadedData: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasLoadedData.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKeys.hasLoadedData.rawValue)
        }
    }
    
    func loadData() {
        guard !hasLoadedData else { return }
        
        Task(priority: .high) {
            await CoreDataStack.shared.loadUsers()
            hasLoadedData = true
        }
    }
}
