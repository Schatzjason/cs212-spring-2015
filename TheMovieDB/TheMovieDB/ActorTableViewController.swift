//
//  ActorTableViewController
//  TheMovieDB
//
//  Created by Jason Schatz on 1/10/15.

import UIKit

class ActorTableViewController: UITableViewController {
    
    var actors = [Person]()
    var movie: Movie?
    
    
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
        super.viewWillAppear(animated)
        
        self.tableView.alpha = 0.2
        
        // Load the movies
        TheMovieDB.sharedInstance().castForMovie(movie!) { result, error in
            
            if let error = error? {
                println(error)
            } else {
                self.actors = result!
                self.tableView.reloadData()
                
                UIView.animateWithDuration(0.3) {
                    self.tableView.alpha = 1
                }
            }
            
        }

    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        let object = actors[indexPath.row] as Person
        cell.textLabel!.text = object.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let navigationController = self.presentingViewController as UINavigationController
        let movieViewController = navigationController.topViewController as MovieTableViewController
        
        movieViewController.person = actors[indexPath.row]
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

