//
//  Post.swift
//  InstgramClone
//
//  Created by Flyco Developer on 27.07.2018.
//  Copyright © 2018 Flyco Global. All rights reserved.
//

import Foundation
class Post {
    var caption: String
    var photoUrl: String
    
    init(captionText: String, photoUrlString: String) {
       caption = captionText
        photoUrl = photoUrlString
    }
}
