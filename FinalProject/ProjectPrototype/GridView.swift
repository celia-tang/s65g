//
//  GridView.swift
//  Final Project
//

import UIKit

@IBDesignable class GridView: UIView {
    
    @IBInspectable var aliveColor: UIColor = UIColor.magentaColor()
    @IBInspectable var emptyColor: UIColor = UIColor.greenColor()
    @IBInspectable var bornColor: UIColor = UIColor.cyanColor()
    @IBInspectable var diedColor: UIColor = UIColor.blueColor()
    @IBInspectable var gridColor: UIColor = UIColor.grayColor()
    @IBInspectable var gridWidth: CGFloat = 2.0
    
    var cell: (x:Int, y:Int)!
    var points:[Position]! {
        get {
            return StandardEngine.sharedInstance.getLiving()
        }
        set {
            self.points = newValue
            StandardEngine.sharedInstance.gridSet(self.points)
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        let path = UIBezierPath()
        path.lineWidth = gridWidth
        let width = bounds.width
        let height = bounds.height
        
        var center: CGPoint
        // doesnt account for gridWidth
        let cellWidth:CGFloat = (width - (CGFloat(StandardEngine.sharedInstance.cols + 1) * gridWidth)) / CGFloat(StandardEngine.sharedInstance.cols)
        let cellHeight:CGFloat = (height - (CGFloat(StandardEngine.sharedInstance.rows + 1) * gridWidth)) / CGFloat(StandardEngine.sharedInstance.rows)
        
        let cellRadius:CGFloat!
        
        cellWidth < cellHeight ? (cellRadius = cellWidth / 2) : (cellRadius = cellHeight / 2)
        
        let xCenter = gridWidth/2
        //for the horizontal strokes
        for i in 0...StandardEngine.sharedInstance.rows {
            
            path.moveToPoint(CGPoint(
                x:xCenter,
                y:xCenter + (CGFloat(i) * (gridWidth + cellHeight))))
            
            path.addLineToPoint(CGPoint(
                x:width,
                y:xCenter + (CGFloat(i) * (gridWidth + cellHeight))))
            
            //set the stroke color
            gridColor.setStroke()
            
            //draw the stroke
            path.stroke()
        }
        
        // for vertical strokes
        for i in 0...StandardEngine.sharedInstance.cols {
            
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
        
        for i in 0..<StandardEngine.sharedInstance.rows {
            for j in 0..<StandardEngine.sharedInstance.cols {
                
                let circlePath = UIBezierPath()
                
                center = CGPoint(
                    x: cellRadius + gridWidth + ((cellWidth + gridWidth) * CGFloat(j)),
                    y: cellRadius + gridWidth + ((cellHeight + gridWidth) * CGFloat(i)))
                circlePath.moveToPoint(center)
                circlePath.addArcWithCenter(center, radius: (cellRadius), startAngle: 0.0, endAngle: 2.0 * CGFloat(M_PI), clockwise: true)
                
                // set color
                switch StandardEngine.sharedInstance.grid[i, j] {
                case .Empty:
                    emptyColor.setFill()
                case .Alive:
                    aliveColor.setFill()
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
        
        i >= 0 ? ((i <= width) ? m = Int(i / (width / CGFloat(StandardEngine.sharedInstance.cols))) : ()) : ()
        j >= 0 ? ((j <= height) ? n = Int(j / (height / CGFloat(StandardEngine.sharedInstance.rows))) : ()) : ()

        return (m, n)
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
        
        if (cell.0 >= 0 && cell.1 >= 0 && cell.0 < StandardEngine.sharedInstance.cols && cell.1 < StandardEngine.sharedInstance.rows) {
            StandardEngine.sharedInstance.toggle(cell.1, j: cell.0)
        }
    }
}
