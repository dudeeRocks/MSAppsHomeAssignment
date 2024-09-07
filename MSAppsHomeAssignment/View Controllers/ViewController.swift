//
//  ViewController.swift
//  MSAppsHomeAssignment
//
//  Created by David Katsman on 05/09/2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button = UIButton(type: .system)
        button.setTitle("Log out", for: .normal)
        button.configuration = .filled()
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200)
        ])
    }


    @objc private func logOut() {
        
        
        AuthManager.isLoggedIn = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
        
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: {$0 is UIWindowScene}) as? UIWindowScene else {
            fatalError("No UIWindowScene")
        }
        
        guard let window = windowScene.windows.first else {
            fatalError("no window found")
        }
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            window.rootViewController = vc
        })
    }
}

