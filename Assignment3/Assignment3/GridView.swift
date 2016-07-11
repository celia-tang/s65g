//
//  GridView.swift
//  Assignment3
//
//  Created by Celia Tang on 2016-07-07.
//  Copyright © 2016 Celia Tang. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class GridView: UIView {
    
    @IBInspectable var livingColor: UIColor = UIColor.magentaColor()
    @IBInspectable var emptyColor: UIColor = UIColor.greenColor()
    @IBInspectable var bornColor: UIColor = UIColor.cyanColor()
    @IBInspectable var diedColor: UIColor = UIColor.blueColor()
    @IBInspectable var gridColor: UIColor = UIColor.grayColor()
    @IBInspectable var gridWidth: CGFloat = 2.0

    var grid: Array<Array<ViewController.CellState>>!
    var cell: (x:Int, y:Int)!
    
    //let box:CGRect = view.bounds;
    
    @IBInspectable var rows: Int = 20 {
        didSet {
            grid = Array(count: rows, repeatedValue: Array(count: cols, repeatedValue: ViewController.CellState.Empty))
        }
    }
    @IBInspectable var cols: Int = 20 {
        didSet {
            grid = Array(count: rows, repeatedValue: Array(count: cols, repeatedValue: ViewController.CellState.Empty))
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        let path = UIBezierPath()
        path.lineWidth = gridWidth
        let width = bounds.width
        let height = bounds.height
        
        var center: CGPoint
        // doesnt account for gridWidth
        let cellWidth:CGFloat = (width - (CGFloat(rows + 1) * gridWidth)) / CGFloat(rows)
        let cellRadius = cellWidth/2
        let xCenter = gridWidth/2
        
        //for the horizontal strokes
        for i in 0...rows {
            
            path.moveToPoint(CGPoint(
                x:xCenter,
                y:xCenter + (CGFloat(i) * (gridWidth + cellWidth))))
            
                path.addLineToPoint(CGPoint(
                x:width,
                y:xCenter + (CGFloat(i) * (gridWidth + cellWidth))))
            
            //set the stroke color
            gridColor.setStroke()
            
            //draw the stroke
            path.stroke()
        }
        
        // for vertical strokes
        for i in 0...cols {
            
            path.moveToPoint(CGPoint(
                x:xCenter + (CGFloat(i) * (gridWidth + cellWidth)),
                y:xCenter))

            path.addLineToPoint(CGPoint(
                x:xCenter + (CGFloat(i) * (gridWidth + cellWidth)),
                y:height))
            
            
            //set the stroke color
            gridColor.setStroke()
            
            //draw the stroke
            path.stroke()
        }
        
        //for circles in grids
        
        for i in 0..<rows {
            for j in 0..<cols {
                
                let circlePath = UIBezierPath()
                
                center = CGPoint(
                    x: cellRadius + gridWidth + ((cellWidth + gridWidth) * CGFloat(i)),
                    y: cellRadius + gridWidth + ((cellWidth + gridWidth) * CGFloat(j)))
                circlePath.moveToPoint(center)
                circlePath.addArcWithCenter(center, radius: (cellRadius), startAngle: 0.0, endAngle: 2.0 * CGFloat(M_PI), clockwise: true)
                
                // set color
                switch grid[i][j] {
                case .Empty:
                    emptyColor.setFill()
                case .Living:
                    livingColor.setFill()
                case .Born:
                    bornColor.setFill()
                case .Died:
                    diedColor.setFill()
                }
                circlePath.fill()
                
            }
        }
    }

    // returns the cell the point corresponds to
    func getCell(point: CGPoint) -> (x: Int ,y: Int){

        let width = bounds.width
        let height = bounds.height
        let i = point.x
        let j = point.y
        var m = -1
        var n = -1

        if (i >= 0) && (i <= width) {
            m = Int(i / (width / CGFloat(rows)))
        }
        
        if (j >= 0) && (j <= height) {
            n = Int(j / (height / CGFloat(cols)))
            
        }
        return (m, n)
    }

    func step(before: Array<Array<ViewController.CellState>>) -> Array<Array<ViewController.CellState>> {
        
        var after = Array(count: rows, repeatedValue: Array(count: cols, repeatedValue: ViewController.CellState.Empty))
        
        for row in 0..<rows {
            for col in 0..<cols {
                
                //switch case to go to next iteration of game
                switch checkNeighbors(row, col: col, array: before) {
                    
                // 3 neighbors
                case 3 :
                    if (before[row][col] == ViewController.CellState.Living || before[row][col] == ViewController.CellState.Born) {
                        after[row][col] = ViewController.CellState.Living
                    } else {
                        after[row][col] = ViewController.CellState.Born
                    }
                // 2 neighbors
                case 2:
                    if (before[row][col] == ViewController.CellState.Living || before[row][col] == ViewController.CellState.Born) {
                        after[row][col] = ViewController.CellState.Living
                    } else {
                        after[row][col] = ViewController.CellState.Empty
                    }
                default:
                    if (before[row][col] == ViewController.CellState.Living || before[row][col] == ViewController.CellState.Born) {
                        after[row][col] = ViewController.CellState.Died
                    } else if (before[row][col] == ViewController.CellState.Died) {
                        after[row][col] = ViewController.CellState.Empty
                    }
                }
            }
        }
        return after
    }
    
    //checks for how many alive cells are surrounding
    func checkNeighbors(row: Int, col: Int, array: Array<Array<ViewController.CellState>>) -> Int {
        var alive = 0
        
        for i in -1...1 {
            for j in -1...1 {
                let item = array[nextInt(row + i, size: rows)][nextInt(col + j, size: cols)]
                if item == ViewController.CellState.Born || item == ViewController.CellState.Living {
                    if ((j != 0) || (i != 0)) {
                        alive += 1
                    }
                }
            }
        }
        return alive
    }
    
    //provides neighboring int considering wrap around
    func nextInt(num: Int, size: Int) -> Int {
        if num >= size {
            return 0
        } else if num < 0 {
            return size - 1
        } else {
            return num
        }
    }
    

    //touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            self.processTouch(touch)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            self.processTouch(touch)
        }
    }
    
    func processTouch(touch: UITouch){
        let point = touch.locationInView(self)
        cell = self.getCell(point)
        
        if (cell.0 >= 0 && cell.1 >= 0 && cell.0 < rows && cell.1 < cols) {
            grid[cell.0][cell.1] = grid[cell.0][cell.1].toggle(grid[cell.0][cell.1])
            
            let width = bounds.width
            let cellWidth:CGFloat = (width - (CGFloat(rows + 1) * gridWidth)) / CGFloat(rows)
            let cellRadius = cellWidth/2
            
            let center = CGPoint(
                    x: cellRadius + gridWidth + ((cellWidth + gridWidth) * CGFloat(cell.0)),
                    y: cellRadius + gridWidth + ((cellWidth + gridWidth) * CGFloat(cell.1)))
            
            let cellDraw = CGRectMake(center.x - (cellRadius), center.y + (cellRadius), cellWidth + 2, cellWidth + 2)

            clearsContextBeforeDrawing = true
            //setNeedsDisplayInRect(cellDraw)
            setNeedsDisplay()
        }
    }
    

}







