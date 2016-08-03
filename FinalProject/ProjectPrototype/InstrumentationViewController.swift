//
//  GridView.swift
//  Final Project
//

import UIKit

class InstrumentationViewController: UIViewController{

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var urlText: UITextField!

    @IBOutlet weak var RowLabel: UILabel!
    @IBOutlet weak var ColLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        RowLabel.text = "\(StandardEngine.sharedInstance.rows)"
        ColLabel.text = "\(StandardEngine.sharedInstance.cols)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var rowValue = 0
    var colValue = 0
    @IBOutlet weak var refreshSwitch: UISwitch!
    
    @IBAction func rowStepper(sender: UIStepper) {
        let temp = Int(sender.value) - rowValue
        StandardEngine.sharedInstance.rows = StandardEngine.sharedInstance.rows + temp
        RowLabel.text = "\(StandardEngine.sharedInstance.rows)"
        rowValue = Int(sender.value)
    }

    @IBAction func colStepper(sender: UIStepper) {
        let temp = Int(sender.value) - colValue
        StandardEngine.sharedInstance.cols = StandardEngine.sharedInstance.cols + temp
        ColLabel.text = "\(StandardEngine.sharedInstance.cols)"
        colValue = Int(sender.value)
    }
    
    @IBAction func refreshSlider(sender: UISlider) {
         StandardEngine.sharedInstance.refreshRate = Double(sender.value)
    }
    
    @IBAction func refreshSwitch(sender: UISwitch) {
        refreshSwitch.on ? (StandardEngine.sharedInstance.refreshOn = true) : (StandardEngine.sharedInstance.refreshOn = false)
    }
    
    @IBAction func reloadButton(sender: AnyObject) {
        let url = NSURL(string: urlText.text!)!
        let fetcher = Fetcher()
            
        fetcher.requestJSON(url) { (json, message) in
            let op = NSBlockOperation {
                if let json = json {
                    let data = json as? Array<AnyObject>
                    
                    for item in data! {
                        if let title = item["title"]! {
                            let t = String(title)
                            if let contents = item["contents"] {
                                let c = (contents as! NSArray) as Array
                                var temp:Array<Position> = c.map { (($0 as? Array<Int>)![0], ($0 as? Array<Int>)![1]) }
                               
                                temp.append(TableModel.sharedInstance.findBounds(temp))

                                TableModel.sharedInstance.patterns[t] = temp
                                TableModel.sharedInstance.names.contains(t) ? () : TableModel.sharedInstance.names.append(t)
                            }
                        }
                    }
                }
                else if let message = message {
                    print(message)
                }
            }
        
            NSOperationQueue.mainQueue().addOperation(op)
        }
    }
}

