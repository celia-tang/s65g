//
//  GridView.swift
//  Final Project
//

import UIKit

class ConfigurationViewController: UITableViewController{

    
    @IBOutlet var tableField: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableField.dataSource = TableModel.sharedInstance
        
        let sel = #selector(StatisticsViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "TableNotification", object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func watchForNotifications(notification:NSNotification){
        tableField.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as? ConfigurationEditorViewController,
        tapIndex = tableField.indexPathForSelectedRow?.row
        let name = TableModel.sharedInstance.names[tapIndex!]
        destination!.contents = TableModel.sharedInstance.patterns[name]!
    }

}
