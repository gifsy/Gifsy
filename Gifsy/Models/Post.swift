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

class Post : PFObject, PFSubclassing {
    
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    
    var image: Observable<UIImage?> = Observable(nil)
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
    
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
        }
    }
    
    func uploadPost() {
        
        if let image = image.value {
            
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
                () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            let imageFile = PFFile(data: imageData!)
            imageFile!.saveInBackgroundWithBlock(nil)
            
            user = PFUser.currentUser()
            self.imageFile = imageFile
            saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
        }
    }
    
    func downloadImage() {
        // if image is not downloaded yet, get it
        if (image.value == nil) {
            imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    // 3
                    self.image.value = image
                }
            }
        }
    }
    
}
