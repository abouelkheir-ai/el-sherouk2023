import UIKit
import FirebaseAuth
import SwiftMessages

class ModernLoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!

    private var loadingTag: Int { return 999999 }
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUIForCurrentTraitCollection()

    }


    // Set content size of the scroll view
    func showSnackBar(message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Snack Bar", body: message)
        view.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        SwiftMessages.show(config: config, view: view)
    }
    
    func setupUI() {
        
               // Add your UI elements to the scroll view
               let label = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 30))
               label.text = "Scroll me!"
        
        
        userName.keyboardType = .emailAddress
        userName.backgroundColor = .white
        password.backgroundColor = .white
        password.delegate = self
        userName.delegate = self
        userName.overrideUserInterfaceStyle = .light // Set this to dark for dark mode
        password.overrideUserInterfaceStyle = .light // Set this to dark for dark mode

                // Other customization for text fields
        // Initialize the activity indicator
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        // Set auto-capitalization type for the username field
        userName.autocapitalizationType = .none

        // Set auto-capitalization type for the password field
        password.autocapitalizationType = .none

        // Set secure text entry mode for the password field
        password.isSecureTextEntry = true

        userName.textContentType = .username
        password.textContentType = .password
        // Add a tap gesture recognizer to dismiss the keyboard when tapping outside of the text fields
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    func updateUIForCurrentTraitCollection() {
            if #available(iOS 13.0, *) {
                let isDarkMode = traitCollection.userInterfaceStyle == .dark

                // Adjust text field colors for light and dark mode
                userName.backgroundColor = isDarkMode ? .darkGray : .white
                userName.textColor = isDarkMode ? .white : .black

                password.backgroundColor = isDarkMode ? .darkGray : .white
                password.textColor = isDarkMode ? .white : .black

                // Other adjustments for different UI elements
            }
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            updateUIForCurrentTraitCollection()
        }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // This method gets called when the return key is pressed
            if textField == userName {
                // If the current text field is the username field, make the password field the first responder
                password.becomeFirstResponder()
            } else if textField == password {
                // If the current text field is the password field, resign the first responder status (dismiss the keyboard)
                view.endEditing(true)
            }
            return true
        }
    // Function to handle email and password login
    func login(email: String, password: String) {
        if isValidEmail(email) {
            showLoadingIndicator()
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else { return }
                self.hideLoadingIndicator()
                if let error = error {
                    if let errorCode = AuthErrorCode.Code(rawValue: error._code) {
                        switch errorCode {
                        case .userNotFound:
                            // User does not have an account, show an alert to create an account
//                            self.showCreateAccount(email: email, password: password)
                            showSnackBar(message: "userNotFound")
                            break
                        default:
                            // Handle other login errors
                            showSnackBar(message: "Login Failed")

                        }
                    } else {
                        // Handle other login errors
                        showSnackBar(message: "Login Failed")

                    }
                } else {
                    // Login successful, show an alert


                    let vcSecondView = self.storyboard?.instantiateViewController(withIdentifier: "home_ui") as! HomeViewController
                    vcSecondView.termBegin = "2023-09-01"
                    vcSecondView.termEnd = "2024-01-31"
                    vcSecondView.userName = userName.text ?? ""
                    self.navigationController?.pushViewController(vcSecondView, animated: true)

                }
            }
        } else {
            // Show an alert for invalid email format
            showSnackBar(message: "Please enter a valid email address.")
        }
    }

   

    // Function to validate email format
    func isValidEmail(_ email: String) -> Bool {
        // Simple email format validation using regular expression
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    @IBAction func signIn(_ sender: Any) {
        // Call the login function with the entered email and password
        guard let email = userName.text, let password = password.text else { return }
        if(email.isEmpty || email == "" ){
            showSnackBar(message: "Please enter a valid email")
        }else if (password.isEmpty || password == "" ){
            showSnackBar(message: "Please enter a valid password")


        }else{
            login(email: email, password: password)

        }
    }
    
   
    
    
    func logout() {
        do {
            try Auth.auth().signOut()
            // Perform necessary actions after logout (e.g., navigate back to the login page)
            print("Logout successful!")
        } catch {
            // Handle logout error
            print("Logout error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        // Call the login function with the entered email and password
        guard let email = userName.text, let password = password.text else { return }
        login(email: email, password: password)
    }
    func showLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.color = .gray
        activityIndicator.tag = loadingTag
        activityIndicator.startAnimating()
        
        DispatchQueue.main.async {
            self.view.addSubview(activityIndicator)
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            if let activityIndicator = self.view.subviews.first(where: { $0.tag == self.loadingTag }) as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            self.view.isUserInteractionEnabled = true
        }
    }
    
    
    
   
}
