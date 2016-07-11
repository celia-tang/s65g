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
    var redraw = false
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
        
        clearsContextBeforeDrawing = true

        let path = UIBezierPath()
        path.lineWidth = gridWidth
        let width = bounds.width * 0.9
        let height = bounds.height * 0.9
        let marginWidth = (bounds.width * 0.1)/2
        let marginHeight = (bounds.height * 0.1)/2
        
        var center: CGPoint
        let cellWidth:CGFloat = (width - (CGFloat(rows + 1) * gridWidth)) / CGFloat(rows)
        let widthCenter:CGFloat = cellWidth/2 + gridWidth
        let cellHeight:CGFloat = (height - (CGFloat(cols + 1) * gridWidth)) / CGFloat(cols)
        let heightCenter:CGFloat = cellHeight/2 + gridWidth
        
        //if redraw == false {
        //for the horizontal strokes
        for i in 0...rows {
            
            //move the initial point of the path to the start of the horizontal stroke
            path.moveToPoint(CGPoint(
                x:marginWidth + width/2 - width/2,
                y:rect.origin.x + marginHeight + ((y:height/CGFloat(rows)) * CGFloat(i))))
            
            //add a point to the path at the end of the stroke
            path.addLineToPoint(CGPoint(
                x:marginWidth + width/2 + width/2,
                y:rect.origin.x + marginHeight + ((y:height/CGFloat(rows)) * CGFloat(i))))
            
            //set the stroke color
            gridColor.setStroke()
            
            //draw the stroke
            path.stroke()
        }
        
        // for vertical strokes
        for i in 0...cols {
            
            //move the initial point of the path to the start of the horizontal stroke
            path.moveToPoint(CGPoint(
                x:rect.origin.y + marginWidth + ((x:width/CGFloat(cols)) * CGFloat(i)),
                y:marginHeight + height/2 - height/2))
            
            //add a point to the path at the end of the stroke
            path.addLineToPoint(CGPoint(
                x:rect.origin.y + marginWidth + ((x:width/CGFloat(cols)) * CGFloat(i)),
                y:marginHeight + height/2 + height/2))
            
            
            //set the stroke color
            UIColor.blackColor().setStroke()
            
            //draw the stroke
            path.stroke()
        }
        
        //for circles in grids
        
        for i in 0..<rows {
            for j in 0..<cols {
                
                let circlePath = UIBezierPath()
                
                center = CGPoint(
                    x: marginWidth + widthCenter + ((cellWidth + gridWidth) * CGFloat(i)),
                    y: marginHeight + heightCenter + ((cellHeight + gridWidth) * CGFloat(j)))
                circlePath.moveToPoint(center)
                circlePath.addArcWithCenter(center, radius: cellWidth/2, startAngle: 0.0, endAngle: 2.0 * CGFloat(M_PI), clockwise: true)
                
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
        
        let marginWidth = (bounds.width * 0.1)/2
        let marginHeight = (bounds.height * 0.1)/2
        let width = bounds.width * 0.9
        let height = bounds.height * 0.9
        let i = point.x
        let j = point.y
        var m = -1
        var n = -1

        if (i > marginWidth) && (i < (marginWidth + width)) {
            m = Int((point.x - marginWidth)) / Int((width / CGFloat(rows)))
        }
        
        if (j > marginHeight) && (j < (marginHeight + height)) {
            n = Int((point.y - marginHeight)) / Int((height / CGFloat(cols)))
            
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
            
            let width = bounds.width * 0.9
            let height = bounds.height * 0.9
            let cellWidth:CGFloat = (width - (CGFloat(rows + 1) * gridWidth)) / CGFloat(rows)
            let cellHeight:CGFloat = (height - (CGFloat(cols + 1) * gridWidth)) / CGFloat(cols)
            let widthCenter:CGFloat = cellWidth/2 + gridWidth
            let heightCenter:CGFloat = cellHeight/2 + gridWidth
            let marginWidth = (bounds.width * 0.1)/2
            let marginHeight = (bounds.height * 0.1)/2
            
            let center = CGPoint(
                x: marginWidth + widthCenter + ((cellWidth + gridWidth) * CGFloat(cell.0)),
                y: marginHeight + heightCenter + ((cellHeight + gridWidth) * CGFloat(cell.1)))
            
//            let cellDraw = CGRect(
//                origin: CGPoint(
//                    x: center.x - (cellWidth/2),
//                    y: center.y + (cellHeight/2)),
//                size: CGSize(
//                    width: cellWidth,
//                    height: cellHeight))
//            
            redraw = true
            //self.setNeedsDisplayInRect(cellDraw)
            self.setNeedsDisplay()
        }
    }
    

}







