//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    private let authManager = AuthManager()
    
    private var isRegisterMode: Bool = false
    
    // MARK: - IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var primaryButton: UIButton!
    @IBOutlet var secondaryButton: UIButton!
    @IBOutlet var secondaryButtonLabel: UILabel!
    @IBOutlet var formContainer: UIStackView!
    
    // MARK: - IBActions
    
    @IBAction func onPrimaryButtonTap(_ sender: UIButton) {
        let userName: String = userNameTextField.text ?? ""
        let password: String = passwordTextField.text ?? ""
        do {
            if isRegisterMode {
                try authManager.register(userName: userName, password: password)
            } else {
                try authManager.login(userName: userName, password: password)
            }
            
            showMainScreen()
        } catch {
            showAlert(for: error)
        }
    }
    
    @IBAction func onSecondaryButtonTap(_ sender: UIButton) {
        isRegisterMode.toggle()
        
        UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.updateUI()
        })
    }
    
    // MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attachTapGesture()
        setTextFieldDelegates()
        updateUI()
    }
    
    // MARK: - Methods
    
    private func updateUI() {
        if isRegisterMode {
            titleLabel.text = "Register"
            primaryButton.setTitle("Sign Up", for: .normal)
            secondaryButton.setTitle("Sign In", for: .normal)
            secondaryButtonLabel.text = "Already registered?"
        } else {
            titleLabel.text = "Login"
            primaryButton.setTitle("Sign In", for: .normal)
            secondaryButton.setTitle("Sign Up", for: .normal)
            secondaryButtonLabel.text = "Not registered?"
        }
        userNameTextField.text = ""
        passwordTextField.text = ""
    }
    
    private func attachTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func showMainScreen() {
        let mainScreen: UIViewController = .getViewController(withIdentifier: .main)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: {$0 is UIWindowScene}) as? UIWindowScene else {
            fatalError("No UIWindowScene")
        }
        
        guard let window = windowScene.windows.first else {
            fatalError("no window found")
        }
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
            window.rootViewController = mainScreen
        })
    }
    
    private func showAlert(for error: Error) {
        var title: String = ""
        var message: String = ""
        
        if let authError = error as? AuthError {
            title = authError.title
            message = authError.message
        } else {
            title = "Error"
            message = error.localizedDescription
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            onPrimaryButtonTap(primaryButton)
        }
        return true
    }
    
    private func setTextFieldDelegates() {
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }
}

