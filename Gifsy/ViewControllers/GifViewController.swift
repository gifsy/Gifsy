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
    @IBOutlet weak var tableView: UITableView!
    
    var searchResults: [AXCGiphy]?
    
    // MARK: Update search result list
    
    /**
    Is called as the completion block of all queries.
    As soon as a query completes, this method updates the Table View.
    */
    func updateSearchResults(results: [AnyObject]?, error: NSError?) {
        
        if let error = error {
            ErrorHandling.defaultErrorHandler(error)
        }
        
        self.searchResults = results as? [AXCGiphy] ?? []
        
        NSOperationQueue.mainQueue().addOperationWithBlock({() -> Void in
            self.tableView.reloadData()
        })
    }
}

// MARK: TableView Data Source

extension GifViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GifCell") as! GifSearchTableViewCell
        
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
