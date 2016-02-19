//
//  PostSectionHeaderView.swift
//  Gifsy
//
//  Created by Martin Spier on 2/19/16.
//  Copyright © 2016 Gifsy. All rights reserved.
//

import UIKit

class PostSectionHeaderView: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    
    var post: Post? {
        didSet {
            if let post = post {
                usernameLabel.text = post.user?.username
                postTimeLabel.text = post.createdAt?.shortTimeAgoSinceDate(NSDate()) ?? ""
            }
        }
    }
}
