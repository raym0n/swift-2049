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
    var isGameBoardDirty = false
    
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
        isGameBoardDirty = packLeft()
    
        
        
        if (isGameBoardDirty) {
            addToBoard()
        }
        
        return isGameBoardDirty
    }

    func packLeft() -> Bool {
        var isDirty = false
        
        for y in 0..numRows
        {
            var slice = board[(y * numRows)..(y * numCols + numCols)]
            
            println(y * numRows)
            println(y * numCols + numCols)
            println(slice)
            
            let result = packL(y, slice: slice)
            
            if (result){
                isDirty = true
            }
        }
        
        return isDirty
    }
    
    func packL(y: Int, slice: Slice<Int>) -> Bool {
        
        var isDirty = false
        var currentFreeX = 0
        var currentOccupiedX = 0
        
        for x in 0..numCols{
            let currentValue = slice[x]
     
            if (currentValue > 0){
                
                //check last occupied
                let currentOccupiedValue = slice[currentOccupiedX]
                let currentUnoccupiedValue = slice[currentFreeX]
                
                if currentOccupiedValue == currentValue && x != currentOccupiedX {
                    //printArray()
                    slice[currentOccupiedX] = currentValue * 2
                    slice[x] = 0
                    //printArray()
                    
                    isDirty = true
                }
                else if x != currentFreeX && currentUnoccupiedValue == 0  {
                    //printArray()
                    slice[currentFreeX] = currentValue
                    slice[x] = 0
                    
                    currentOccupiedX = currentFreeX
                    currentFreeX++
                    
                    isDirty = true
                    //printArray()
                }
                else {
                    currentFreeX++
                    currentOccupiedX = x
                }
            }
        }
        
        return isDirty
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