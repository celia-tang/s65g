//
//  Engine.swift
//  Assignment2
//
//  Created by Celia Tang on 2016-07-02.
//  Copyright © 2016 Celia Tang. All rights reserved.
//

import UIKit

class Engine {
    
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
    
    //check neighbors function and returns amount of neighbors alive
    func checkNeighbors(col: Int, row: Int, array: Array<Array<Bool>>) -> Int {
        var alive = 0
        
        for i in -1...1 {
            for j in -1...1 {
                if array[nextInt(col + i, size: array.count)][nextInt(row + j, size: array.count)] {
                    if ((j != 0) || (i != 0)) {
                        alive += 1
                    }
                }
            }
        }
        return alive
    }

    //count array function
    func countArray(array: Array<Array<Bool>>, size: Int) -> Int {
        var count = 0
        
        for column in 0..<size {
            for row in 0..<size {
                if array[column][row] == true {
                    count+=1
                }
            }
        }
        return count
    }
    
    // takes a tuple and returns an array of it's neighbors
    func neighbors(point: (Int, Int), size: Int) -> Array<(Int, Int)> {
        var neighbors : [(Int, Int)] = []
        for i in -1...1 {
            for j in -1...1 {
                if ((j != 0) || (i != 0)) {
                    neighbors.append((nextInt(point.0 + i, size: size), nextInt(point.1 + j, size: size)))
                }
            }
        }
        return neighbors
    }
    
    func step(before: Array<Array<Bool>>) -> Array<Array<Bool>> {
        
        let size = before.count
        var after = Array(count: size, repeatedValue:[Bool](count: size, repeatedValue:false))
        
        for column in 0..<size {
            for row in 0..<size {
                
                //switch case to go to next iteration of game
                switch checkNeighbors(column, row: row, array: before) {
                    
                    // 3 neighbors
                    case 3 :
                        after[column][row] = true
                    // 2 neighbors
                    case 2:
                        if before[column][row] {
                            after[column][row] = true
                        } else {
                            after[column][row] = false
                        }
                    default:
                        after[column][row] = false
                }
            }
        }
        return after
    }
    
    func step2(before: Array<Array<Bool>>) -> Array<Array<Bool>> {
        
        let size = before.count
        var after = Array(count: size, repeatedValue:[Bool](count: size, repeatedValue:false))
        
        for column in 0..<size {
            for row in 0..<size {
            
                var alive = 0
                let neighbor = neighbors((column, row), size: size)
                for item in neighbor {
                    if before[item.0][item.1] {
                        alive += 1
                    }
            }
            
            //switch case to go to next iteration of game
            switch alive {
            
                // 3 neighbors
                case 3 :
                    after[column][row] = true
                // 2 neighbors
                case 2:
                    if before[column][row] {
                        after[column][row] = true
                    } else {
                        after[column][row] = false
                    }
                default:
                    after[column][row] = false
                }
            }
        }
        
        return after

        
    }

}