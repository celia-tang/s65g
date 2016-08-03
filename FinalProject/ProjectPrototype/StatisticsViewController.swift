//
//  GridView.swift
//  Final Project
//

import UIKit

class StatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let sel = #selector(StatisticsViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "UpdateNotification", object: nil)
        
        let info = StandardEngine.sharedInstance.count()
        deadLabel.text = String(info["Died"]!)
        emptyLabel.text = String(info["Empty"]!)
        aliveLabel.text = String(info["Alive"]!)
        bornLabel.text = String(info["Born"]!)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var deadLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var aliveLabel: UILabel!
    @IBOutlet weak var bornLabel: UILabel!
    
    func watchForNotifications(notification:NSNotification){
        let d = String(notification.userInfo!["Died"]!)
        let e = String(notification.userInfo!["Empty"]!)
        let a = String(notification.userInfo!["Alive"]!)
        let b = String(notification.userInfo!["Born"]!)
        
        deadLabel.text = d
        emptyLabel.text = e
        aliveLabel.text = a
        bornLabel.text = b
    }
}
