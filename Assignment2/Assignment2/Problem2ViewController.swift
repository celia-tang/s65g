//
//  Problem2Controller.swift
//  Assignment2
//
//  Created by Celia Tang on 2016-07-01.
//  Copyright © 2016 Celia Tang. All rights reserved.
//

import UIKit

class Problem2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Problem 2"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func IBAction(sender: UIButton) {
        IBOutlet.text = "Hello World"
    }
    
    @IBOutlet weak var IBOutlet: UITextView!
    
    
    
}