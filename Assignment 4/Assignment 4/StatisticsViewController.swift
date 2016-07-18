//
//  StatisticsViewController.swift
//  Assignment 4
//
//  Created by Celia Tang on 2016-07-13.
//  Copyright © 2016 Celia Tang. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController, EngineDelegate {
    
    @IBOutlet weak var DiedLabel: UILabel!
    @IBOutlet weak var EmptyLabel: UILabel!
    @IBOutlet weak var BornLabel: UILabel!
    @IBOutlet weak var LivingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        let sel = #selector(StatisticsViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "UpdateNotification", object: nil)
        
        
        let info = StandardEngine.sharedInstance.count()
        DiedLabel.text = String(info["Died"]!)
        EmptyLabel.text = String(info["Empty"]!)
        LivingLabel.text = String(info["Living"]!)
        BornLabel.text = String(info["Born"]!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func engineDidUpdate(engine: EngineProtocol, withGrid: GridProtocol){
        
    }
    
    func watchForNotifications(notification:NSNotification){
        let d = String(notification.userInfo!["Died"]!)
        let e = String(notification.userInfo!["Empty"]!)
        let a = String(notification.userInfo!["Living"]!)
        let b = String(notification.userInfo!["Born"]!)
        
        DiedLabel.text = d
        EmptyLabel.text = e
        LivingLabel.text = a
        BornLabel.text = b
    }
    
    
}
