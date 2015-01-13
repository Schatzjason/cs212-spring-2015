//
//  ActorTableViewController
//  TheMovieDB
//
//  Created by Jason Schatz on 1/10/15.

import UIKit

class ActorTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var storyboardNavigationItem: UINavigationItem!
    
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
        
        // Dim the table, and empty it
        self.tableView.alpha = 0.2
        actors = [Person]()
        tableView.reloadData()

        // Set the title
        if let title = movie?.title {
            storyboardNavigationItem.title = title
        }
        
        // Load the movies
        
        println("Step 1 - View Controller asks for actors")
        
        TheMovieDB.sharedInstance().castForMovie(movie!) { result, error in
            if let error = error? {
                println(error)
            } else {
                println("Step 6 - Final step. Completion handler in View Controller. Reloads table data.")
                self.actors = result!
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.tableView.reloadData()
                    
                    UIView.animateWithDuration(0.3) {
                        self.tableView.alpha = 1
                    }
                }
            }
        }
    }
    
    @IBAction func returnToMovies(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        let actor = actors[indexPath.row] as Person
        cell.textLabel!.text = actor.name
        
        println(actor.name)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let navigationController = self.presentingViewController as UINavigationController
        let movieViewController = navigationController.topViewController as MovieTableViewController
        
        movieViewController.person = actors[indexPath.row]
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

