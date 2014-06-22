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
    
    var undo = Array<Int>()
    var board = Array<Int>()
    var freeTilesLeft = 16
    var isGameBoardDirty = false
    var canUndo = false
    var score = 0
    
    init(){
        startGame()
    }
    
    func startGame() {
        freeTilesLeft = numRows * numCols
        
        board = Array(count: freeTilesLeft, repeatedValue: 0)
        
        undo = []
        canUndo = false
        score = 0
        
        addToBoard()
        addToBoard()
    }
    
    func isGameOver() -> Bool {
        if (freeTilesLeft <= 0) {
            //perform tests to see if the game can progress any further
            let left = performSwipe(Swipe.Left)
            let right = performSwipe(Swipe.Right)
            let up = performSwipe(Swipe.Up)
            let down = performSwipe(Swipe.Down)
            
            if (board != left || board != right || board != up || board != down) {
                //we can perform an action
                return false
            }
            
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
    
    func performUndo() {
        
        if (canUndo) {
            board = undo.copy()
            undo = []
            
            canUndo = false
            isGameBoardDirty = true
        }
    }
    
    func performSwipe(swipe: Swipe) -> Bool {
        println(swipe)
        
        let newBoard = doSwipeAction(swipe)
        
        if (newBoard != board) {
            undo = board
            canUndo = true
        }
        
        board = newBoard

        if (isGameBoardDirty) {
            addToBoard()
        }
        
        return isGameBoardDirty
    }
    
    func doSwipeAction(swipe: Swipe) -> Array<Int> {
        
        var copy = board.copy()
        
        switch swipe {
        case .Left:
            for y in 0..numRows
            {
                var slice = copy[(y * numRows)..(y * numCols + numCols)]
                
                pack(slice)
                
                copy[(y * numRows)..(y * numCols + numCols)] = slice
            }
            
        case .Right:
            for y in 0..numRows
            {
                var slice:Slice<Int> = []
                
                for x in 0..numCols {
                    slice.insert(copy[y*numCols + x], atIndex: 0)
                }
                
                pack(slice)
                
                for x in 0..numCols {
                    copy[y*numCols + x] = slice[numCols - x - 1]
                }
            }
            
        case .Up:
            for x in 0..numCols
            {
                var slice:Slice<Int> = []
                
                for y in 0..numRows {
                    slice += copy[x + numRows * y]
                }
                
                pack(slice)
                
                for y in 0..numRows {
                    copy[x + numRows * y] = slice[y]
                }
            }
            
        case .Down:
            for x in 0..numCols
            {
                var slice:Slice<Int> = []
                
                for y in 0..numRows {
                    slice.insert(copy[x + numRows * y], atIndex: 0)
                }
                
                pack(slice)
                
                for y in 0..numRows {
                    copy[x + numRows * y] = slice[numRows - y - 1]
                }
            }
            
            
        default:
            break
        }
        
        return copy
    }
    
    func pack(slice: Slice<Int>) {

        var currentFreeX = 0
        var currentOccupiedX = 0
        
        for x in 0..numCols{
            let currentValue = slice[x]
     
            if (currentValue > 0){
                
                //check last occupied
                let currentOccupiedValue = slice[currentOccupiedX]
                let currentUnoccupiedValue = slice[currentFreeX]
                
                if currentOccupiedValue == currentValue && x != currentOccupiedX {
                    
                    score += currentValue
                    
                    slice[currentOccupiedX] = currentValue * 2
                    slice[x] = 0
                    
                    freeTilesLeft++
                    
                    isGameBoardDirty = true
                }
                else if x != currentFreeX && currentUnoccupiedValue == 0  {
                    slice[currentFreeX] = currentValue
                    slice[x] = 0
                    
                    currentOccupiedX = currentFreeX
                    currentFreeX++
                    
                    isGameBoardDirty = true
                }
                else {
                    currentFreeX++
                    currentOccupiedX = x
                }
            }
        }
    }
    

    
    func addToBoard() -> Bool {
        if (freeTilesLeft <= 0) {
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