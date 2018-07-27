//
//  HomeViewController.swift
//  InstgramClone
//
//  Created by Flyco Developer on 16.07.2018.
//  Copyright © 2018 Flyco Global. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // change color of view
        loadPosts()
        //var post = Post(captionText: "text", photoUrlString: "url1")
       // print(post.caption)
       // print(post.photoUrl)
    }

    
    func loadPosts() {
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot : DataSnapshot) in
            print(Thread.isMainThread)
            if let dict = snapshot.value as? [String: Any] {
                let captionText = dict["caption"] as! String
                let photoUrlString = dict["photoUrl"] as! String
                let post = Post(captionText: captionText, photoUrlString: photoUrlString)
                self.posts.append(post)
                print(self.posts)
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func logout_TouchUpInside(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let stoayboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = stoayboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil )
        } catch let logoutEror {
            print(logoutEror)
        }
        
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
}
