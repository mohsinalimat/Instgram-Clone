//
//  AuthService.swift
//  InstgramClone
//
//  Created by Flyco Developer on 17.07.2018.
//  Copyright © 2018 Flyco Global. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    static func signIn(email:String, password: String, onSuccess: @escaping () -> Void, onError: @escaping(_ errorMessage:String?) -> Void){
   Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
    if error != nil {
        onError(error!.localizedDescription)
    return
    }
    onSuccess()
    }
}
    
    static func signUp(username:String, email:String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping(_ errorMessage:String?) -> Void){
        Auth.auth().createUser(withEmail: email, password:password) { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            let uid = user?.user.uid
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    let profileImageUrl = metadata?.path
                    self.setUserInformation(profileImageUrl: profileImageUrl!, username: username, email: email, uid: uid!, onSuccess: onSuccess)
                })
    }
}

    static func setUserInformation(profileImageUrl:String, username:String, email:String, uid:String, onSuccess: @escaping () -> Void) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users")
        let newUsersReference = usersReference.child(uid)
        newUsersReference.setValue(["username":username,"email":email, "profileImageUrl":profileImageUrl])
    onSuccess()
}
}
