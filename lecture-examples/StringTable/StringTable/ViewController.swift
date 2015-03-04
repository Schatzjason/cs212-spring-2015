


import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var colors: [String: UIColor] = [
        "Red" : UIColor.redColor(),
        "Orange" : UIColor.orangeColor(),
        "Yellow" : UIColor.yellowColor(),
        "Green" : UIColor.greenColor(),
        "Blue" : UIColor.blueColor(),
        "Gray" : UIColor.grayColor(),
        "Brown" : UIColor.brownColor()
    ]
    
    var colorNames: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorNames = colors.keys.array
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get a reuable cell from the table view
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as ColorTableViewCell
        
        // Configure the cell
        let colorName = colorNames[indexPath.row]

        cell.colorLabel.text = colorName
        cell.rightColorSquare.backgroundColor = colors[colorName]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        cell.detailTextLabel
        
        // Return the cell
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(colorNames[indexPath.row]);
    }

}

