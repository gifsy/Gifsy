//
//  Post.swift
//  Gifsy
//
//  Created by Martin Spier on 2/17/16.
//  Copyright © 2016 Gifsy. All rights reserved.
//

import Foundation
import Parse
import Bond
import ConvenienceKit

class Post : PFObject, PFSubclassing {
    
    @NSManaged var user: PFUser?
    @NSManaged var gifUrl: String?
    @NSManaged var caption: String?
    
    static var imageDataCache: NSCacheSwift<String, NSData>!
    
    var imageData: Observable<NSData?> = Observable(nil)
    var likes: Observable<[PFUser]?> = Observable(nil)
    
    var savePostTask: UIBackgroundTaskIdentifier?
    
    //MARK: PFSubclassing Protocol
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
            Post.imageDataCache = NSCacheSwift<String, NSData>()
        }
    }
    
    func getDataFromUrl(url: String, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func savePost() {
        savePostTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.savePostTask!)
        }
        
        user = PFUser.currentUser()
        saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            
            UIApplication.sharedApplication().endBackgroundTask(self.savePostTask!)
        }
    }
    
    func downloadImage() {
        imageData.value = Post.imageDataCache[self.gifUrl!]
        
        // if image is not downloaded yet, get it
        if (imageData.value == nil) {
            
            getDataFromUrl(self.gifUrl!) { (data, response, error)  in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { return }
                    
                    // let image = UIImage.gifWithData(data)
                    self.imageData.value = data
                    Post.imageDataCache[self.gifUrl!] = data
        
                }
            }
        }
    }
    
    func fetchLikes() {
        if (likes.value != nil) {
            return
        }
        
        ParseHelper.likesForPost(self, completionBlock: { (var likes: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            
            likes = likes?.filter { like in like[ParseHelper.ParseLikeFromUser] != nil }
            
            self.likes.value = likes?.map { like in
                let fromUser = like[ParseHelper.ParseLikeFromUser] as! PFUser
                
                return fromUser
            }
        })
    }
    
    func doesUserLikePost(user: PFUser) -> Bool {
        if let likes = likes.value {
            return likes.contains(user)
        } else {
            return false
        }
    }
    
    func toggleLikePost(user: PFUser) {
        if (doesUserLikePost(user)) {
            // if image is liked, unlike it now
            likes.value = likes.value?.filter { $0 != user }
            ParseHelper.unlikePost(user, post: self)
        } else {
            // if this image is not liked yet, like it now
            likes.value?.append(user)
            ParseHelper.likePost(user, post: self)
        }
    }
    
}
