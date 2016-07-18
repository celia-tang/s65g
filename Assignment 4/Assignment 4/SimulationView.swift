//
//  SimulationView.swift
//  Assignment 4
//
//  Created by Celia Tang on 2016-07-17.
//  Copyright © 2016 Celia Tang. All rights reserved.
//

import Foundation
import UIKit

class SimulationView: UIView {
    
    var gridWidth: CGFloat = 2.0
    var livingColor: UIColor = UIColor.magentaColor()
    var emptyColor: UIColor = UIColor.greenColor()
    var bornColor: UIColor = UIColor.cyanColor()
    var diedColor: UIColor = UIColor.blueColor()
    var gridColor: UIColor = UIColor.grayColor()
    internal var engine: EngineProtocol!
    
    override func drawRect(rect: CGRect) {
        
        let path = UIBezierPath()
        path.lineWidth = gridWidth
        let width = bounds.width
        let height = bounds.height
        
        var center: CGPoint
        // doesnt account for gridWidth
        let cellWidth:CGFloat = (width - (CGFloat(engine.cols + 1) * gridWidth)) / CGFloat(engine.cols)
        let cellHeight:CGFloat = (height - (CGFloat(engine.rows + 1) * gridWidth)) / CGFloat(engine.rows)
        
        let cellRadius:CGFloat!
        if cellWidth < cellHeight {
            cellRadius = cellWidth / 2
        } else {
            cellRadius = cellHeight / 2
        }
        
        let xCenter = gridWidth/2
        
        //for the horizontal strokes
        for i in 0...engine.rows {
            
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
        for i in 0...engine.cols {
            
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
        
        for i in 0..<engine.rows {
            for j in 0..<engine.cols {
                
                let circlePath = UIBezierPath()
                
                center = CGPoint(
                    x: cellRadius + gridWidth + ((cellWidth + gridWidth) * CGFloat(j)),
                    y: cellRadius + gridWidth + ((cellHeight + gridWidth) * CGFloat(i)))
                circlePath.moveToPoint(center)
                circlePath.addArcWithCenter(center, radius: (cellRadius), startAngle: 0.0, endAngle: 2.0 * CGFloat(M_PI), clockwise: true)
                
                // set color
                switch engine.grid[Int(i), Int(j)] {
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

}