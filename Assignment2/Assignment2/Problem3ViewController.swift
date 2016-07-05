//
//  Problem3ViewController.swift
//  Assignment2
//
//  Created by Celia Tang on 2016-07-01.
//  Copyright © 2016 Celia Tang. All rights reserved.
//

import UIKit

class Problem3ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Problem 3"
        
        before = Array(count: size, repeatedValue:[Bool](count: size, repeatedValue:false))
        
        // loop through before array and set initial values
        for column in 0..<size {
            for row in 0..<size {
                if arc4random_uniform(3) == 1 {
                    // set current cell to alive
                    before[column][row] = true
                } else {
                    before[column][row] = false
                }
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let size = 10
    var before : Array<Array<Bool>> = []
    
    @IBAction func IBAction(sender: UIButton) {
        let engine = Engine()
        let after = engine.step(before)
        
        IBOutlet.text = "Before: \(engine.countArray(before, size: size)) \nAfter: \(engine.countArray(after, size: size))"
        before = after
    }
    
    @IBOutlet weak var IBOutlet: UITextView!
    
}