//
//  SimulationViewController.swift
//  Assignment 4
//
//  Created by Celia Tang on 2016-07-13.
//  Copyright © 2016 Celia Tang. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate{
    
    @IBOutlet weak var GridView: SimulationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        StandardEngine.sharedInstance.engineDelegate = self
        GridView.engine = StandardEngine.sharedInstance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func StepButton(sender: AnyObject) {
        StandardEngine.sharedInstance.step()
        GridView.setNeedsDisplay()
    }
    
    
    func engineDidUpdate(engine: EngineProtocol, withGrid: GridProtocol) {
        GridView.setNeedsDisplay()
    }


}

