//
//  MovieListViewController.swift
//  FavoriteActors
//
//  Created by Jason on 1/31/15.
//  Copyright (c) 2015 CCSF. All rights reserved.
//

import UIKit
import CoreData

class MovieListViewController : UITableViewController {
    
    var actor: Person!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if actor.movies.isEmpty {
            
            let resource = TheMovieDB.Resources.PersonIDMovieCredits
            var parameters = [TheMovieDB.Keys.ID : actor.id]
            
            TheMovieDB.sharedInstance().taskForResource(resource, parameters: parameters){ JSONResult, error  in
                if let error = error {
                    self.alertViewForError(error)
                } else {
                    
                    if let moviesDictionaries = JSONResult.valueForKey("cast") as? [[String : AnyObject]] {
                        
                        // Parse the array of movies dictionaries
                        var movies = moviesDictionaries.map() { (dictionary: [String : AnyObject]) -> Movie in
                            let movie = Movie(dictionary: dictionary)
                            
                            // We associate this movie with it's actor by appending it to the array
                            // In core data we use the relationship. We set the movie's actor property
                            self.actor.movies.append(movie)
                            
                            return movie
                        }
                        
                        // Update the table on the main thread
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                    } else {
                        let error = NSError(domain: "Movie for Person Parsing. Cant find cast in \(JSONResult)", code: 0, userInfo: nil)
                        self.alertViewForError(error)
                    }
                }
            }
        }
    }
    
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actor.movies.count
    }
    
    /**
    The downloading of movie posters is handled here. Notice how the method uses a unique
    table view cell that holds on to a task so that it can be canceled.
    */
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movie = actor.movies[indexPath.row]
        let CellIdentifier = "MovieCell"
        var posterImage = UIImage(named: "posterPlaceHoldr")
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as TaskCancelingTableViewCell
        
        cell.textLabel!.text = movie.title
        cell.imageView!.image = nil
        
        // Set the Movie Poster Image
        
        if  movie.posterPath == nil || movie.posterPath == "" {
            posterImage = UIImage(named: "noImage")
        } else if movie.posterImage != nil {
            posterImage = movie.posterImage
        }
            
        else { // This is the interesting case. The movie has an image name, but it is not downloaded yet.
            
            // This first line returns a string representing the second to the smallest size that TheMovieDB serves up
            let size = TheMovieDB.sharedInstance().config.posterSizes[1]
            
            // Start the task that will eventually download the image
            let task = TheMovieDB.sharedInstance().taskForImageWithSize(size, filePath: movie.posterPath!) { data, error in
                
                if let error = error {
                    println("Poster download error: \(error.localizedDescription)")
                }
                
                if let data = data {
                    // Craete the image
                    let image = UIImage(data: data)
                    
                    // update the model, so that the infrmation gets cashed
                    movie.posterImage = image
                    
                    // update the cell later, on the main thread
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.imageView!.image = image
                    }
                }
            }
            
            // This is the custom property on this cell. See TaskCancelingTableViewCell.swift for details.
            cell.taskToCancelifCellIsReused = task
        }
        
        cell.imageView!.image = posterImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (editingStyle) {
        case .Delete:
            actor.movies.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            break
        }
    }
    
    // MARK: - Alert View
    
    func alertViewForError(error: NSError) {
        
    }
}































