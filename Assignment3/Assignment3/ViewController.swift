//
//  ViewController.swift
//  Assignment3
//
//  Created by Celia Tang on 2016-07-06.
//  Copyright © 2016 Celia Tang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func IBAction(sender: AnyObject) {
        IBOutlet.grid = IBOutlet.step(IBOutlet.grid)
        IBOutlet.setNeedsDisplay()
    }
    
    @IBOutlet weak var IBOutlet: GridView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum CellState: String {
        
        case Living, Empty, Born, Died
        
        func description() -> String {
            switch self {
            case .Living:
                return "Living"
            case .Empty:
                return "Empty"
            case .Born:
                return "Born"
            case .Died:
                return "Died"
            }
        }
        
        func allValues() -> Array<String> {
            return ["Living", "Empty", "Born", "Died"]
        }
        
        func toggle(value: CellState) -> CellState {
            switch value {
            case .Empty:
                return .Living
            case .Died:
                return .Living
            case .Living:
                return .Empty
            case .Born:
                return .Empty
            }
            
        }
    }

}

