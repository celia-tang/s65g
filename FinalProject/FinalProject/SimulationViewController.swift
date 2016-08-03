
//
//  GridView.swift
//  Final Project
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate {

    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        StandardEngine.sharedInstance.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stepButton(sender: UIButton) {
        StandardEngine.sharedInstance.step()
        gridView.setNeedsDisplay()
    }
    
    @IBAction func resetButton(sender: UIButton) {
        StandardEngine.sharedInstance.reset()
        gridView.setNeedsDisplay()
    }
    
    @IBAction func saveButton(sender: UIButton) {
        
        var nameField:UITextField!
        
        func configurationTextField(textField: UITextField!){
            textField.text = "Name"
            nameField = textField
        }
        
        
        let alert = UIAlertController(title: "Save",
                                      message:"Enter the name: ",
                                      preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{ (UIAlertAction) in
            let bounds:Position = (StandardEngine.sharedInstance.rows, StandardEngine.sharedInstance.cols)
            var state = StandardEngine.sharedInstance.getLiving()
            state.append(bounds)
            TableModel.sharedInstance.patterns[nameField.text!] = state
            TableModel.sharedInstance.names.contains(nameField.text!) ? () : TableModel.sharedInstance.names.append(nameField.text!)
            }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default) { _ in })
        
        self.presentViewController(alert, animated: true){}
        }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        gridView.setNeedsDisplay()
    }

}

