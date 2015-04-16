//
//  DetailViewController.swift
//  CDMasterDetail
//
//  Created by jschatz on 4/14/15.
//  Copyright (c) 2015 jschatz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    // This is called a "property observer". It declares the "detailItem" property. and
    // also lets us run a little bit of code whenever it is set
    var detailItem: Event? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {

        if let detailItem = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detailItem.timeStamp.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

}

