//
//  ViewController.swift
//  TheMovie
//
//  Created by jschatz on 3/10/15.
//

import UIKit

class ViewController : UIViewController, UITableViewDataSource {
    
    var movies = [[String : AnyObject]]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(animated: Bool) {

        let session = NSURLSession.sharedSession()
        let url = NSURL(string: kevinBaconMoviesURL)!
        
        var task = session.dataTaskWithURL(url) {(data, response, error) -> Void in
        
            if let error = error? {
                println("error downloading poster: \(error)")
            } else {
                
                if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                    
                    if let movieArray = jsonObject["cast"] as? [[String: AnyObject]] {
                        self.movies = movieArray
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Table View Data Source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        let movie = movies[indexPath.row] as [String : AnyObject]
        let title = movie["title"] as? String ?? "No Title"
        let posterPath = movie["poster_path"] as? String ?? "No Poster"
        
        cell.textLabel!.text = title
        cell.detailTextLabel!.text = posterPath
        
        return cell
    }
}




