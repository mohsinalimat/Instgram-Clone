//
//  ViewController.swift
//  InstgramClone
//
//  Created by Flyco Developer on 13.07.2018.
//  Copyright © 2018 Flyco Global. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.tintColor = UIColor.white
        emailTextField.textColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 5)
        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1.0).cgColor
        bottomLayerEmail.backgroundColor = UIColor.white.cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)
        
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 5)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1.0).cgColor
        bottomLayerPassword.backgroundColor = UIColor.white.cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)
        signInButton.isEnabled = false
        handleTextField()
        
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
                self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
            }
        }   

    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        
    }
    @objc func textFieldDidChange() {
        guard  let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
    signInButton.setTitleColor(UIColor.lightText, for: .normal)
            signInButton.isEnabled = false
            return
        }
        signInButton.setTitleColor(UIColor.white, for: .normal)
        signInButton.isEnabled = true
    }
    @IBAction func sigInButton_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        AuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
        }) { (errorMessage) in
            //print(errorMessage!)
        }
    }
}

