//
//  PostTableViewCell.swift
//  Gifsy
//
//  Created by Martin Spier on 2/17/16.
//  Copyright © 2016 Gifsy. All rights reserved.
//

import UIKit
import Bond

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    var post: Post? {
        didSet {
            if let post = post {
                // bind the image of the post to the 'postImage' view
                post.image.bindTo(postImageView.bnd_image)
            }
        }
    }
    
}
