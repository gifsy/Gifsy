//
//  GifSearchCollectionViewCell.swift
//  Gifsy
//
//  Created by Martin Spier on 2/19/16.
//  Copyright © 2016 Gifsy. All rights reserved.
//

import Foundation
import UIKit
import Giphy_iOS

class GifSearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL) {
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.imageView.image = UIImage.gifWithData(data)
            }
        }
    }
    
    var gif: AXCGiphy? {
        didSet {
            downloadImage(gif!.originalImage.url)
            //downloadImage(NSURL(string: "http://i.giphy.com/8RczH5vL2k7Ju.gif")!)
        }
    }
}