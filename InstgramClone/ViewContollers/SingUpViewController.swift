//
//  SingUpViewController.swift
//  InstgramClone
//
//  Created by Flyco Developer on 13.07.2018.
//  Copyright © 2018 Flyco Global. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SingUpViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextfField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var selectedImage:UIImage?
    
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()



        usernameTextField.backgroundColor = UIColor.clear
        usernameTextField.tintColor = UIColor.white
        usernameTextField.textColor = UIColor.white
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerUsername = CALayer()
        bottomLayerUsername.frame = CGRect(x: 0, y: 29, width: 1000, height: 5)
        bottomLayerUsername.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1.0).cgColor
        bottomLayerUsername.backgroundColor = UIColor.white.cgColor
       usernameTextField.layer.addSublayer(bottomLayerUsername)
        
        
        emailTextfField.backgroundColor = UIColor.clear
        emailTextfField.tintColor = UIColor.white
        emailTextfField.textColor = UIColor.white
        emailTextfField.attributedPlaceholder = NSAttributedString(string: emailTextfField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 5)
        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1.0).cgColor
        bottomLayerEmail.backgroundColor = UIColor.white.cgColor
        emailTextfField.layer.addSublayer(bottomLayerEmail)
        
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 5)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1.0).cgColor
        bottomLayerPassword.backgroundColor = UIColor.white.cgColor
    passwordTextField.layer.addSublayer(bottomLayerPassword)
        
        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
       let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        signUpButton.isEnabled = false
        handleTextField()
        
    }
    
    
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        emailTextfField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)

    }

    @objc func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextfField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpButton.setTitleColor(UIColor.lightText, for: .normal)
            signUpButton.isEnabled = false
            return
        }
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.isEnabled = true
    }
    
   
    @objc func handleSelectProfileImageView() {
    let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
 
    @IBAction func signUpNtn_TocuhInside(_ sender: Any) {
        view.endEditing(true)
       if let profileImage = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
        
        AuthService.signUp(username: usernameTextField.text!, email: emailTextfField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
            self.performSegue(withIdentifier: "signUpToTabbarVC", sender: nil)
        }) { (errorString) in
            print(errorString!)
        }
       } else {
        print("Profile Image can't be empty")
        }
    }
}

extension SingUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Did Finish Picking Media")
         if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
        
    }
}












