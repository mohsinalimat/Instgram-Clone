//
//  CameraViewController.swift
//  InstgramClone
//
//  Created by Flyco Developer on 16.07.2018.
//  Copyright © 2018 Flyco Global. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class CameraViewController: UIViewController {
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet var removeButton: UIBarButtonItem!
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(self.handleSelectedPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
    func handlePost()  {
        if selectedImage != nil {
            self.shareButton.isEnabled = true
            self.removeButton.isEnabled = true
            self.shareButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            self.shareButton.isEnabled = false
            self.removeButton.isEnabled = false
            self.shareButton.backgroundColor = UIColor.lightGray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleSelectedPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        if let profileImage = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
            let photoIdString = NSUUID().uuidString
            print(photoIdString)
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(photoIdString)
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                let photoUrl = metadata?.path
                self.sendDataToDatabase(photoUrl: photoUrl!)
            })
        } else {
            // print("Profile Image can't be empty")
        }
    }
    
    @IBAction func remove_TouchUpInside(_ sender: Any) {
       clean()
       handlePost()
    }
    
    func sendDataToDatabase(photoUrl: String) {
        let ref = Database.database().reference()
        let postsReference = ref.child("posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostsReference = postsReference.child(newPostId)
        newPostsReference.setValue(["photoUrl": photoUrl, "caption": captionTextView.text!]) { (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("Success")
            self.clean()
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    func clean() {
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "picture_placeholder.png")
        self.selectedImage = nil
    }

}
extension CameraViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            photo.image = image
        }
        dismiss(animated: true, completion: nil)
        
    }
}


