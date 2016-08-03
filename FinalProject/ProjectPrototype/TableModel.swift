//
//  TableModel.swift
//  FinalProject
//

import Foundation
import UIKit


class TableModel: NSObject {
    
    static var _sharedInstance: TableModel = TableModel()
    static var sharedInstance: TableModel { get { return _sharedInstance } }
    
    var patterns: Dictionary<String, Array<Position>> = [:] {
        didSet {
            
            let center = NSNotificationCenter.defaultCenter()
            let n = NSNotification(name: "TableNotification",
                                   object: nil,
                                   userInfo: nil)
            center.postNotification(n)
        }
    }
    
    var names: Array<String> = []
    var rows = 20
    var cols = 20
    var grid:GridProtocol {
        didSet {
            if let delegate = delegate {
                delegate.engineDidUpdate(self.grid)
            }
        }
    }
    
    override init() {
        grid = Grid(self.rows, self.cols)
    }
    
    weak var delegate: EngineDelegate?
    
    func findBounds(points: Array<Position>) -> Position {
        var x = 0
        for item in points {
            item.row > x ? x = item.row : ()
            item.col > x ? x = item.col : ()
        }
        return (x + 1, x + 1)
    }
    
    func setBounds(points: Array<Position>){
        let index = points.count - 1
        self.rows = points[index].row
        self.cols = points[index].col
        grid = Grid(points[index].row, points[index].col)
    }
    
    func gridSet(points:[Position]) -> GridProtocol {
        var newGrid = Grid(self.rows, self.cols)
        let living = points[0..<points.count - 1]
        for point in living {
            newGrid[point.row, point.col] = .Alive
        }
        grid = newGrid
        if let delegate = delegate { delegate.engineDidUpdate(grid) }
        return grid
    }
    
    func toggle(i:Int, j:Int) {
        grid[i, j].isLiving() ? (grid[i, j] = .Empty) : (grid[i, j] = .Alive)
    }
    
    func getLiving() -> [Position] {
        let items = grid.cells.filter { $0.state.isLiving() }
        let points = items.map { $0.position }
        
        return points
    }
}


extension TableModel: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patterns.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Default") as! CellView

        cell.titleLabel.text = String(names[indexPath.row])
        return cell
    }
}
