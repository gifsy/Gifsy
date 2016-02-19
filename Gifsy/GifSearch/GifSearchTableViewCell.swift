//
//  GifSearchTableViewCell.swift
//  Gifsy
//
//  Created by Martin Spier on 2/19/16.
//  Copyright © 2016 Gifsy. All rights reserved.
//

import Foundation
import UIKit
import Giphy_iOS

class GifSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gifLabel: UILabel!
    
    var gif: AXCGiphy? {
        didSet {
            gifLabel.text = gif?.bitlyURL.absoluteString
        }
    }
    
}