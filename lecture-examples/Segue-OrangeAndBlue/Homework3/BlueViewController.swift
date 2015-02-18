//
//  BlueViewController.swift
//  Homework3
//
//  Created by Jason on 1/25/15.
//  Copyright (c) 2015 CCSF. All rights reserved.
//

import UIKit

class BlueViewController : UIViewController {

    // This is the property that the OrangeViewController uses to pass the 
    // value into this view controller
    var value = 0
    
    @IBOutlet weak var label: UILabel!
    
    // When the view appears, we updated the label
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        label.text = "\(value)"
    }
    
    @IBAction func returnToOrangeController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
