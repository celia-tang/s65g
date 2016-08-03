//
//  GridView.swift
//  Final Project
//

import UIKit

class ConfigurationEditorViewController: UIViewController, EngineDelegate {
    @IBOutlet weak var gridView: GridEditView!

    var contents: Array<Position> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableModel.sharedInstance.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        TableModel.sharedInstance.setBounds(contents)
        TableModel.sharedInstance.gridSet(contents)
        gridView.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        StandardEngine.sharedInstance.rows = TableModel.sharedInstance.rows
        StandardEngine.sharedInstance.cols = TableModel.sharedInstance.cols
        StandardEngine.sharedInstance.grid = TableModel.sharedInstance.grid
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        gridView.setNeedsDisplay()
    }


}
