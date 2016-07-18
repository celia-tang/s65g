//
//  Engine.swift
//  Assignment 4
//
//  Created by Celia Tang on 2016-07-15.
//  Copyright © 2016 Celia Tang. All rights reserved.
//

import Foundation

protocol GridProtocol {
    init(rows: UInt, cols: UInt)
    var rows: UInt { get }
    var cols: UInt { get }
    func neighbors(coordinate: (UInt, UInt)) -> [(UInt, UInt)]
    subscript(row: Int, col: Int) -> CellState { get set }
}

protocol EngineDelegate {
    func engineDidUpdate(engine: EngineProtocol, withGrid: GridProtocol)
}

protocol EngineProtocol {
    var engineDelegate : EngineDelegate? { get set }
    var grid : GridProtocol { get }
    var refreshRate : Double { get set }
    var refreshTimer : NSTimer? { get set }
    var rows : UInt { get set }
    var cols : UInt { get set }
    init(rows: UInt, cols: UInt)
    func step() -> GridProtocol
}

extension EngineProtocol {
    var refreshRate: Double { return 0.0 }
}

class Grid: GridProtocol {
    var rows: UInt
    var cols: UInt
    private var grid: [[CellState]]
    required init(rows: UInt, cols: UInt) {
        self.rows = rows
        self.cols = cols
        self.grid = Array(count: Int(self.rows), repeatedValue: Array(count: Int(self.cols), repeatedValue: CellState.Empty))
        
        // loop through before array and set initial values
        for row in 0..<Int(self.rows) {
            for col in 0..<Int(self.cols) {
                if arc4random_uniform(3) == 1 {
                    // set current cell to alive
                    self.grid[row][col] = .Born
                }
            }
        }

    }
    
    //provides neighboring int considering wrap around
    private func nextInt(num: Int, size: Int) -> Int {
        if num >= size {
            return 0
        } else if num < 0 {
            return size - 1
        } else {
            return num
        }
    }
    
    func neighbors(coordinate: (UInt, UInt)) -> [(UInt, UInt)] {
        var n : Array<(UInt, UInt)> = []
        for i in -1...1 {
            for j in -1...1 {
                let x = nextInt(Int(coordinate.0), size: Int(self.rows))
                let y = nextInt(Int(coordinate.1), size: Int(self.cols))
                if ((j != 0) || (i != 0)) {
                    n.append((UInt(x) ,UInt(y)))
                }
            }
        }
        return n
    }
    
    subscript(row: Int, col: Int) -> CellState {
        get {
            return self.grid[row][col]
        }
        set (newValue) {
            self.grid[row][col] = newValue
        }
    }
}


class StandardEngine: EngineProtocol {
    
    private static var _sharedInstance = StandardEngine(rows: 10, cols: 10)
    static var sharedInstance: StandardEngine {
        get {
            return _sharedInstance
        }
    }
    
    var engineDelegate: EngineDelegate?
    
    var rows: UInt {
        didSet {
            if let engineDelegate = engineDelegate {
                engineDelegate.engineDidUpdate(self, withGrid: Grid(rows: self.rows, cols: self.cols))
            }
        }
    }
    var cols: UInt {
        didSet {
            if let engineDelegate = engineDelegate {
                engineDelegate.engineDidUpdate(self, withGrid: Grid(rows: self.rows, cols: self.cols))
            }
        }
    }
    required init (rows:UInt, cols:UInt) {
        self.rows = rows
        self.cols = cols
    }
    
    var refreshTimer: NSTimer?
    
    func count() -> Dictionary<String, Int> {
        
        var born = 0
        var living = 0
        var empty = 0
        var died = 0
        
        for i in 0..<Int(self.rows){
            for j in 0..<Int(self.cols) {
                
                switch grid[i, j].description(){
                case "Born":
                    born += 1
                case "Living":
                    living += 1
                case "Empty":
                    empty += 1
                default:
                    died += 1
                }
                
            }
        }
        return ["Born" : born, "Living" : living, "Empty" : empty, "Died": died]
    }

    var grid:GridProtocol = Grid(rows: 10, cols: 10) {
        didSet {
            if let engineDelegate = engineDelegate {
                engineDelegate.engineDidUpdate(self, withGrid: Grid(rows:self.rows, cols: self.cols))
                
                let center = NSNotificationCenter.defaultCenter()
                let n = NSNotification(name: "UpdateNotification",
                                       object: nil,
                                       userInfo: count())
                center.postNotification(n)
            }
        }
    }
    var refreshOn = false {
        didSet {
            let sel = #selector(timerDidFire(_:))
            if let refreshTimer = refreshTimer {
                refreshTimer.invalidate()
            }
            if refreshRate <= 0 {
                refreshRate = 0.1
            }
            
            refreshTimer = nil
            refreshTimer = NSTimer.scheduledTimerWithTimeInterval(1/refreshRate,
                                                                  target: self,
                                                                  selector: sel,
                                                                  userInfo: nil,
                                                                  repeats: refreshOn)
            if refreshOn {
                refreshTimer!.fire()
            }  else {
                refreshTimer!.invalidate()
            }
            
        }
    }
    
    var refreshRate: Double = 0.0 {
        didSet {
            if refreshRate > 0 {
                if let refreshTimer = refreshTimer {
                    refreshTimer.invalidate()
                }
                
                let sel = #selector(timerDidFire(_:))
                refreshTimer = nil
                refreshTimer = NSTimer.scheduledTimerWithTimeInterval(1/refreshRate,
                                                                      target: self,
                                                                      selector: sel,
                                                                      userInfo: nil,
                                                                      repeats: refreshOn)
                if refreshOn {
                    refreshTimer!.fire()
                }
            } else if let refreshTimer = refreshTimer {
                refreshTimer.invalidate()
            }
        }
    }
    
    var timer = 0
    
    @objc func timerDidFire(timer:NSTimer) {
        
        self.step()
        let center = NSNotificationCenter.defaultCenter()
        let n = NSNotification(name: "TimerNotification",
                               object: nil,
                               userInfo: self.count())
        center.postNotification(n)
        self.timer += 1
    }
    
    //provides neighboring int considering wrap around
    private func nextInt(num: Int, size: Int) -> Int {
        if num >= size {
            return 0
        } else if num < 0 {
            return size - 1
        } else {
            return num
        }
    }
    
    //checks for how many alive cells are surrounding
    private func checkNeighbors(row: Int, col: Int) -> Int {
        var alive = 0
        
        for i in -1...1 {
            for j in -1...1 {
                let item = self.grid[nextInt(row + i, size: Int(self.rows)), nextInt(col + j, size: Int(self.cols))]
                if item == CellState.Born || item == CellState.Living {
                    if ((j != 0) || (i != 0)) {
                        alive += 1
                    }
                }
            }
        }
        return alive
    }
    
    func step() -> GridProtocol {
        
        let after = Grid(rows: self.rows, cols: self.cols)
        
        for row in 0..<Int(rows) {
            for col in 0..<Int(cols) {
                
                //switch case to go to next iteration of game
                switch checkNeighbors(Int(row), col: Int(col)) {
                    
                // 3 neighbors
                case 3 :
                    if (self.grid[row, col] == CellState.Living || self.grid[row, col] == CellState.Born) {
                        after[row, col] = CellState.Living
                    } else {
                        after[row, col] = CellState.Born
                    }
                // 2 neighbors
                case 2:
                    if (self.grid[row, col] == CellState.Living || self.grid[row, col] == CellState.Born) {
                        after[row, col] = CellState.Living
                    } else {
                        after[row, col] = CellState.Empty
                    }
                default:
                    if (self.grid[row, col] == CellState.Living || self.grid[row, col] == CellState.Born) {
                        after[row, col] = CellState.Died
                    } else if (self.grid[row, col] == CellState.Died) {
                        after[row, col] = CellState.Empty
                    }
                }
            }
        }
        
        self.grid = after
        
        return after
    }
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
