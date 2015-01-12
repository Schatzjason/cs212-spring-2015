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
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Dim the table, and empty it
        self.tableView.alpha = 0.2
        movies = [Movie]()
        tableView.reloadData()
        
        // Define the handler
        func handler(results: [Movie]?, error: NSError?) {
        
            
            if let error = error? {
                println(error)
            } else {
                self.movies = results!
                self.tableView.reloadData()
                
                UIView.animateWithDuration(0.3) {
                    self.tableView.alpha = 1
                }
            }
        }
        
        // Apply it to the person, or to Kevin Bacon
        if let person = person? {
            TheMovieDB.sharedInstance().moviesForPerson(person, handler)
        } else {
            TheMovieDB.sharedInstance().moviesForKevinBacon(handler)
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

