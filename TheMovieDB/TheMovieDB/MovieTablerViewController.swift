//
//  MasterViewController.swift
//  TheMovieDB
//
//  Created by Jason Schatz on 1/10/15.
//

import UIKit

class MovieTableViewController: UITableViewController {

    var movies = [Movie]()
    var person: Person?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Dim the table, and empty it
        self.tableView.alpha = 0.2
        movies = [Movie]()
        tableView.reloadData()
        
        // Define the handler
        var handler: (results: [Movie]?, error: NSError?) -> Void  = {[unowned self] results, error in
        
            
            if let error = error? {
                println(error)
            } else {
                println("Step 6 - Final step. Completion handler in View Controller. Reloads table data.")
                self.movies = results!
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.tableView.reloadData()
                    
                    UIView.animateWithDuration(0.3) {
                        self.tableView.alpha = 1
                    }
                }
            }
        }
        
        // Apply it to the person, or to Kevin Bacon
        
        println("Step 1 - View Controller asks for movies.")
        
        if let person = person? {
            TheMovieDB.sharedInstance().moviesForPerson(person, handler)
            navigationItem.title = person.name
        } else {
            TheMovieDB.sharedInstance().moviesForKevinBacon(handler)
            navigationItem.title = "Kevin Bacon"
        }
    }

    // MARK: - Segues

     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showActors" {

            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let movie = movies[indexPath.row]
                (segue.destinationViewController as ActorTableViewController).movie = movie
            }
        }
    }

    // MARK: - Table View

     override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
     }

     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = movies[indexPath.row]
        cell.textLabel!.text = object.title
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showActors", sender: self)
    }
}

