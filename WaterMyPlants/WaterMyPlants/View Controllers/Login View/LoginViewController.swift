//
//  LoginViewController.swift
//  WaterMyPlants
//
//  Created by Morgan Smith on 8/19/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Enums
    
    enum LoginType {
        case signUp
        case signIn
    }
    
    //MARK: - Properties
    
    let networkController = Networking.sharedNetworkController
    var loginType = LoginType.signUp
    let moc = CoreDataStack.shared.mainContext
    
    //MARK: - IBoutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginSegmentedController: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
    }
    
    
    //MARK: - IBActions
    @IBAction func buttonTapped(_ sender: Any) {
        guard let usernameInput = usernameTextField.text, !usernameInput.isEmpty,
            let passwordInput = passwordTextField.text, !passwordInput.isEmpty else {
                self.errorLabel.alpha = 1
                return
        }
        let newUser = UserRepresentation(username: usernameInput,
                                         password: passwordInput,
                                         phoneNumber: "")

        if loginType == .signUp {
            networkController.registerUser(with: newUser) { (error) in
                if let error = error {
                    print("Error for user registering: \(error)")
                    DispatchQueue.main.async {
                        self.errorLabel.alpha = 1
                        return
                    }
                }
            }
            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true) {
                self.loginType = .signIn
                self.loginSegmentedController.selectedSegmentIndex = 1
                self.signInButton.setTitle("Sign In", for: .normal)
            }
            DispatchQueue.main.async {
                self.errorLabel.alpha = 0
            }
        } else if loginType == .signIn {
            networkController.loginUser(with: newUser) { (error) in
                if let error = error {
                    print("Error for client logging in: \(error)")
                    DispatchQueue.main.async {
                        self.errorLabel.alpha = 1
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.errorLabel.alpha = 0
                    self.performSegue(withIdentifier: "userSignIn", sender: self)
                }
            }

        }
    }

    @IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
        
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
