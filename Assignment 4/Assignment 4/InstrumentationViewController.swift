//
//  InstrumentationViewController.swift
//  Assignment 4
//
//  Created by Celia Tang on 2016-07-13.
//  Copyright © 2016 Celia Tang. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, EngineDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        rowLabel.text = "\(StandardEngine.sharedInstance.rows)"
        colLabel.text = "\(StandardEngine.sharedInstance.cols)"
        StandardEngine.sharedInstance.engineDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var rowLabel: UITextField!
    @IBOutlet weak var colLabel: UITextField!
    
    var colValue = 0
    var rowValue = 0

    @IBOutlet weak var refreshSwitch: UISwitch!
    
    @IBAction func rowStepper(sender: UIStepper) {
        let temp = Int(sender.value) - rowValue
        StandardEngine.sharedInstance.rows = UInt(Int(StandardEngine.sharedInstance.rows) + temp)
        StandardEngine.sharedInstance.grid = Grid(rows: StandardEngine.sharedInstance.rows, cols: StandardEngine.sharedInstance.cols)
        rowLabel.text = "\(StandardEngine.sharedInstance.rows)"
        rowValue = Int(sender.value)
    }
    
    @IBAction func colStepper(sender: UIStepper) {
        let temp = Int(sender.value) - colValue
        StandardEngine.sharedInstance.cols = UInt(Int(StandardEngine.sharedInstance.cols) + temp)
        StandardEngine.sharedInstance.grid = Grid(rows: StandardEngine.sharedInstance.rows, cols: StandardEngine.sharedInstance.cols)
        colLabel.text = "\(StandardEngine.sharedInstance.cols)"
        colValue = Int(sender.value)
    }

    @IBAction func RefreshSlider(sender: UISlider) {
        StandardEngine.sharedInstance.refreshRate = Double(sender.value)
    }
    
    
    @IBAction func refreshSwitch(sender: UISwitch) {
        if refreshSwitch.on {
            StandardEngine.sharedInstance.refreshOn = true
        } else {
            StandardEngine.sharedInstance.refreshOn = false
        }
    }
    
    func engineDidUpdate(engine: EngineProtocol, withGrid: GridProtocol){
    }
}

