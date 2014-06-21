//
//  GameBoard.swift
//  Swift2048
//
//  Created by Peter Sbarski on 20/06/2014.
//  Copyright (c) 2014 Peter Sbarski. All rights reserved.
//

import Foundation

class GameBoard {
    let numRows = 4
    let numCols = 4
    let initialTileValue = 2
    let board = Array<Int>()
    var freeTilesLeft = 16
    
    init(){
        freeTilesLeft = numRows * numCols

        board = Array(count: freeTilesLeft, repeatedValue: 0)
        
        addToBoard()
        addToBoard()
    }
    
    func isGameOver() -> Bool {
        if (freeTilesLeft <= 0) {
            return true
        }
        
        return false
    }
    
    func getValue(x: Int, y: Int) -> Int {
        let index = x % numRows + y * numCols
        return board[index]
    }
    
    func printArray(){
        for y in 0..numRows
        {
            for x in 0..numCols
            {
                print(board[x % numRows + y * numCols])
            }
            println()
        }
    }
    
    func performSwipe(swipe: Swipe) -> Bool {
//        switch swipe {
//        case .Left:
//            
//        }
//  
        packLeft()
    
        let result = addToBoard()
        
        return result
    }
    
    func packLeft() {
        for y in 0..numRows
        {
            var freeSlot = 0
            
            for x in 0..numCols
            {
                let value = board[x % numRows + y * numCols]
                let beforeFreeSlot = max(freeSlot-1, 0)
                
                //can we move to the freeslot?
                if value > 0 {
                    printArray()
                    let leftValue = board[y * numCols + beforeFreeSlot];
                
                    if beforeFreeSlot != x && leftValue == value
                    {
                        board[y * numCols + beforeFreeSlot] = leftValue * 2
                        board[x % numRows + y * numCols] = 0
                        freeTilesLeft++
                    }
                    else if freeSlot != x
                    {
                        board[y * numCols + freeSlot] = value
                        board[x % numRows + y * numCols] = 0
                    }
                    

                    freeSlot++
                    printArray()
                }
                else if value > 0
                {
                    freeSlot++
                }
            }
        }
    }
    
    func addToBoard() -> Bool {
        if (isGameOver()) {
            return false
        }
        
        for attempt in 0..3 {
            var position = generateRandomPosition()
        
            if board[position] == 0 {
                board[position] = initialTileValue
                freeTilesLeft--;
                
                return true
            }
        }
        
        for i in 0..freeTilesLeft {
            if board[i] == 0 {
                board[i] = initialTileValue
                freeTilesLeft--;
                return true
            }
        }
        
        return false
    }
    
    func generateRandomPosition() -> Int {
        return Int(arc4random_uniform(16))
    }
}