//
//  UserDetailViewController.swift
//  WaterMyPlants
//
//  Created by Morgan Smith on 8/19/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    
    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var phoneNumberTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!

    let networkController = Networking.sharedNetworkController
    
    
    @IBAction func save(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser =  Networking.sharedNetworkController.currentCDUser
        guard let user = currentUser else { return }
        if user.avatar == "" {
            userImage.image = UIImage(named: "defaultAvatar")
        } else {
            userImage.image = UIImage(named: user.avatar ?? "defaultAvatar")
        }
        usernameTextField.text = user.username
        phoneNumberTextField.text = user.phoneNumber
        passwordTextField.text = user.password
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
