//
//  ActorPickerViewController.swift
//  FavoriteActors
//
//  Created by Jason on 1/31/15.
//  Copyright (c) 2015 CCSF. All rights reserved.
//

import UIKit
import CoreData

protocol ActorPickerViewControllerDelegate {
    func actorPicker(actorPicker: ActorPickerViewController, didPickActor actor: Person?)
}


class ActorPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    
    // The data for the table
    var actors = [Person]()
    
    // The delegate will typically be a view controller, waiting for the Actor Picker
    // to return an actor
    var delegate: ActorPickerViewControllerDelegate?
    
    // The most recent data download task. We keep a reference to it so that it can
    // be canceled every time the search text changes
    var searchTask: NSURLSessionDataTask?
    
    
    // MARK: - life Cycle
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchBar.becomeFirstResponder()
    }
    
    
    // MARK: - Actions
    
    @IBAction func cancel() {
        self.delegate?.actorPicker(self, didPickActor: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Search Bar Delegate
    
    // Each time the search text changes we want to cancel any current download and start a new one
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        // If the text is empty we are done
        if searchText == "" {
            actors = [Person]()
            tableView?.reloadData()
            objc_sync_exit(self)
            return
        }
        
        // Start a new one download
        let resource = TheMovieDB.Resources.SearchPerson
        let parameters = ["query" : searchText]
        
        searchTask = TheMovieDB.sharedInstance().taskForResource(resource, parameters: parameters) { [unowned self] jsonResult, error in
            
            // Handle the error case
            if let error = error {
                println("Error searching for actors: \(error.localizedDescription)")
                return
            }
            
            // Get a Swift dictionary from the JSON data
            if let actorDictionaries = jsonResult.valueForKey("results") as? [[String : AnyObject]] {
                self.searchTask = nil
                
                // Create an array of Person instances from the JSON dictionaries
                // If we change this so that it inserts into a context, which context should it be? 
                self.actors = actorDictionaries.map() {
                    Person(dictionary: $0)
                }
                
                // Reload the table on the main thread
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView!.reloadData()
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Table View Delegate and Data Source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellReuseId = "ActorSearchCell"
        let actor = actors[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId) as UITableViewCell
        
        cell.textLabel!.text = actor.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let actor = actors[indexPath.row]
        
        // Alert the delegate
        delegate?.actorPicker(self, didPickActor: actor)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }    
}





