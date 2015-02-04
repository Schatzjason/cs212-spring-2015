//
//  ViewController.swift
//  ClickCounter-AllCode
//
//  Created by jschatz on 2/3/15.
//  Copyright (c) 2015 jschatz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var count: Int = 0
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.orangeColor()
        
        // Create a button
        var button = UIButton()
        
        // func setTitle(title: String, forState: UIControlState) {...}
        button.setTitle("Click", forState: UIControlState.Normal)
        button.frame = CGRectMake(140, 160, 100, 50)
        button.addTarget(self, action: "buttonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Add the button as a subview of self.view
        view.addSubview(button)
        
        // Create a label
        self.label = UILabel(frame: CGRectMake(140, 260, 100, 50))
        self.label.textAlignment = NSTextAlignment.Center
        self.label.text = "0"
        
        // Add the text field as a subiew
        self.view.addSubview(self.label)
        
    }
    
    func buttonClicked() {
        count++
        label.text = "\(count)"
    }
}




