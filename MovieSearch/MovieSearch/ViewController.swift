
import UIKit

/**
 * The Storyboard for the class has been started, but not completed. You will want to 
 * make the following changes: 
 *
 * - Connect the Search button to the @IBAction
 * - Connect the text field to the textField @IBOutlet
 * - Connect the table view to the tableView @IBOutlet
 * - Add a cell to the table view and give it a reuse identifier
 * - Implement UITableViewDataSource, and set the data source in the table view
 *
 * When the user taps the search button, the app will invoke the following
 * Method:
 *
 *    TheMovieDB.sharedInstance().moviesForSearchString(textField.text) {// completion }
 *
 * In the completion handler you should set the movies property, and reload the table data
 */

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // This array should populate the table with movie titles
    var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func searchForMovie(sender: UIButton) {
        // do the search here....
    }
}

