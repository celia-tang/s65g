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
        
        before = Array(count: 10, repeatedValue:[Bool](count: 10, repeatedValue:false))
        after = Array(count: 10, repeatedValue:[Bool](count: 10, repeatedValue:false))
        
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
    
    @IBOutlet weak var IBOutlet: UITextView!
    
    
    let size = 10
    var before : Array<Array<Bool>> = []
    var after : Array<Array<Bool>> = []
    
    @IBAction func IBAction(sender: UIButton) {
        
        //count array function
        func countArray(array: Array<Array<Bool>>) -> Int {
            var count = 0
            
            for column in 0..<size {
                for row in 0..<size {
                    if array[column][row] == true {
                        count+=1
                    }
                }
            }
            return count
        }
        
        //provides neighboring int considering wrap around
        func nextInt(num: Int) -> Int {
            if num >= size {
                return 0
            } else if num < 0 {
                return size - 1
            } else {
                return num
            }
        }
        
        //check neighbors function and returns amount of neighbors alive
        func checkNeighbors(col: Int, row: Int) -> Int {
            var alive = 0
            
            for i in -1...1 {
                for j in -1...1 {
                    if before[nextInt(col + i)][nextInt(row + j)] {
                        if ((j != 0) || (i != 0)) {
                                alive += 1
                        }
                    }
                }
            }
            return alive
        }
    
        for column in 0..<size {
            for row in 0..<size {
                
                //switch case to go to next iteration of game
                switch checkNeighbors(column, row: row) {
            
                // 3 neighbors
                case 3 :
                    after[column][row] = true
                // 2 neighbors
                case 2:
                    if before[column][row] {
                        after[column][row] = true
                    } else {
                        after[column][row] = false
                    }
                default:
                    after[column][row] = false
                }
            }
        }
        
        IBOutlet.text = ("Before: \(countArray(before)) \nAfter: \(countArray(after))")
        before = after
    }
}