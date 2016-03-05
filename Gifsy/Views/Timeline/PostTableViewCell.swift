//
//  PostTableViewCell.swift
//  Gifsy
//
//  Created by Martin Spier on 2/17/16.
//  Copyright © 2016 Gifsy. All rights reserved.
//

import UIKit
import Bond
import Parse
import Gifu

class PostTableViewCell: UITableViewCell {
    
    var postDisposable: DisposableType?
    var likeDisposable: DisposableType?
    
    @IBOutlet weak var postImageView: AnimatableImageView!
    @IBOutlet weak var likesImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBAction func moreButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        post?.toggleLikePost(PFUser.currentUser()!)
    }
    
    var post: Post? {
        didSet {
            
            postDisposable?.dispose()
            likeDisposable?.dispose()
            // free memory of image stored with post that is no longer displayed
            if let oldValue = oldValue where oldValue != post {
                oldValue.imageData.value = nil
            }
            
            if let post = post {
                // postDisposable = post.image.bindTo(postImageView.bnd_image)
                
                postDisposable = post.imageData.observe { (value: NSData?) -> () in
                    self.postImageView.animateWithImageData(value!)
                }
                
                likeDisposable = post.likes.observe { (value: [PFUser]?) -> () in
                    if let value = value {
                        self.likesLabel.text = self.stringFromUserList(value)
                        self.likeButton.selected = value.contains(PFUser.currentUser()!)
                        self.likesImageView.hidden = (value.count == 0)
                    } else {
                        self.likesLabel.text = ""
                        self.likeButton.selected = false
                        self.likesImageView.hidden = true
                    }
                }
            }
        }
    }
    
    // Generates a comma separated list of usernames from an array (e.g. "User1, User2")
    func stringFromUserList(userList: [PFUser]) -> String {
        let usernameList = userList.map { user in user.username! }
        let commaSeparatedUserList = usernameList.joinWithSeparator(", ")
        
        return commaSeparatedUserList
    }
    
}
