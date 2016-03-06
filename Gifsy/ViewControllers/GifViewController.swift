//
//  GifViewController.swift
//  Gifsy
//
//  Created by Martin Spier on 2/16/16.
//  Copyright © 2016 Gifsy. All rights reserved.
//

import UIKit
import Giphy_iOS

class GifViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchResults: [AXCGiphy]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Share"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel:")
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    
    func cancel(sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        assert(sender as? UICollectionViewCell != nil, "Sender is not a collection view.")
        
        if let indexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell) {
            if segue.identifier == "selectGif" {
                let viewController: PostGifViewController = segue.destinationViewController as! PostGifViewController
                let gif = searchResults![indexPath.row]
                viewController.gif = gif
            }
        } else {
            // Error sender is not a cell or cell is not in collectionView.
        }
    }
    
    // MARK: Update search result list
    
    /**
    Is called as the completion block of all queries.
    As soon as a query completes, this method updates the Table View.
    */
    func updateSearchResults(results: [AnyObject]?, error: NSError?) {
        
        if let error = error {
            if error.code == -1 { // Giphy throws an exception in case no results were found.
                 self.searchResults = []
            } else {
                ErrorHandling.defaultErrorHandler(error)
            }
        }
        
        self.searchResults = results as? [AXCGiphy] ?? []
        
        NSOperationQueue.mainQueue().addOperationWithBlock({() -> Void in
            self.collectionView.reloadData()
        })
    }
}

// MARK: TableView Data Source

extension GifViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchResults?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GifCell", forIndexPath: indexPath) as! GifSearchCollectionViewCell
        
        let gif = searchResults![indexPath.row]
        cell.gif = gif
        
        return cell
    }
}

// MARK: Searchbar Delegate

extension GifViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        AXCGiphy.searchGiphyWithTerm(searchText, limit: 10, offset: 0, completion: updateSearchResults)
    }
}

// MARK: Collection View Delegate

extension GifViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Doing nothing.
    }

}