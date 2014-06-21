//
//  GameScene.swift
//  Swift2048
//
//  Created by Peter Sbarski on 17/06/2014.
//  Copyright (c) 2014 Peter Sbarski. All rights reserved.
//

import SpriteKit
import Darwin

class GameScene: SKScene {
    let gridWidth = 200
    let gridHeight = 200

    let blockHeight = 40
    let blockWidth = 40
    let spaceBetweenBlocks = 4
    
    var colours: Dictionary<Int, UIColor> = [:]
    var selectedNode:SKNode? = nil
    
    var swipeDirection:Swipe = Swipe.None
    var gameBoard:GameBoard
    var isDirty:Bool = false
    
    init(sceneSize:CGSize){
        gameBoard = GameBoard()
        
        super.init(size: sceneSize)
        self.backgroundColor = UIColor.whiteColor()
        
        
        gridWidth = (Int)(self.size.width);
        gridHeight = (gridWidth)
        
        blockWidth = (gridWidth - (spaceBetweenBlocks * (gameBoard.numCols + 1))) / gameBoard.numCols
        blockHeight = (gridHeight - (spaceBetweenBlocks * (gameBoard.numRows + 1))) / gameBoard.numRows

        colours =
            [0: UIColor(red: 1, green: 0.97, blue: 0.74, alpha: 1), 2: UIColor(red:1, green:0.95, blue: 0.95, alpha: 1), 4: UIColor(red: 1, green: 0.95, blue: 0.9, alpha: 1), 8: UIColor(red: 1, green: 0.95, blue: 0.8, alpha: 1),
            16: UIColor(red: 1, green: 0.95, blue: 0.7, alpha: 1), 32: UIColor(red: 1, green: 0.95, blue: 0.6, alpha: 1), 64: UIColor(red: 1, green: 0.95, blue: 0.5, alpha: 1), 128: UIColor(red: 1, green: 0.95, blue: 0.4, alpha: 1),
            256: UIColor(red: 1, green: 0.8, blue: 0, alpha: 1), 512: UIColor(red: 1, green: 0.6, blue: 0, alpha: 1), 1024: UIColor(red: 1, green: 0.4, blue: 0, alpha: 1), 2048:UIColor(red: 1, green: 0.2, blue: 0, alpha: 1)]
    }
    
    override func didMoveToView(view: SKView!){
        for y in 0..gameBoard.numRows {
            for x in 0..gameBoard.numCols {
                let tile = SKSpriteNode()
                tile.position = CGPoint(x:  (x * blockWidth) + spaceBetweenBlocks * (x+1),  y: 100 + (y * blockHeight) + spaceBetweenBlocks * (y+1))
                tile.anchorPoint = CGPoint(x: 0, y: 0)

                tile.size = CGSize(width: blockWidth, height: blockHeight)
                tile.zPosition = 0
                tile.name = "node: \(x)_\(y)"
                
                self.addChild(tile)
                
                let gameValue = gameBoard.getValue(x, y: y);
                let label = AddLabel(gameValue == 0 ? "" : (String)(gameValue))
               
                tile.color = colours[gameValue]
                
                tile.addChild(label)
            }
        }
    }
    
    
    func AddLabel(label: String) -> SKLabelNode {
        var node = SKLabelNode()
        node.text = label
        node.fontName = "HelveticaNeue-Thin"
        node.fontSize = 35
        node.fontColor = UIColor.brownColor()
        node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        node.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        node.zPosition = 1
        node.position = CGPoint(x: blockWidth/2, y: blockHeight/2)
        return node
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        if (selectedNode != nil){
            return
        }
        
        if (gameBoard.isGameOver()){
            return
        }
        
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        if var node = self.nodeAtPoint(location) {
            
            if node is SKLabelNode {
                node = node.parent! as SKSpriteNode
            }
            
            if (node is SKSpriteNode) {
                let colour = SKAction.fadeAlphaTo(0.5, duration: 0)
                node.runAction(colour)
                selectedNode = node
            }
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        if (selectedNode != nil) {
            let touch = touches.anyObject() as UITouch
            let location = touch.locationInNode(self)
            if var node = self.nodeAtPoint(location) {
                
                if node is SKLabelNode {
                    node = node.parent! as SKSpriteNode
                }
                
                if (node is SKSpriteNode) {
                    let colour = SKAction.fadeAlphaTo(0.5, duration: 0)
                    node.runAction(colour)
                }
            }
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        if (selectedNode != nil){
            
            let touch = touches.anyObject() as UITouch
            let location = touch.locationInNode(self)
            
            if let node = (self.nodeAtPoint(location)) {
                    let swipeHorizontal = selectedNode!.position.x - node.position.x
                    let swipeVertical = selectedNode!.position.y - node.position.y
                    
                    swipeDirection.updateSwipe((Int)(swipeHorizontal), y: (Int)(swipeVertical))
                    gameBoard.performSwipe(swipeDirection)
                    
                    isDirty = true
                    selectedNode = nil
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if (isDirty)
        {
            for y in 0..gameBoard.numRows {
                for x in 0..gameBoard.numCols {
                    
                    let gameValue = gameBoard.getValue(x, y: y);
                    let node = self.children[x % gameBoard.numRows + y * gameBoard.numCols] as SKSpriteNode
                    
                    let colour = SKAction.fadeAlphaTo(1, duration: 0)
                    node.runAction(colour)
                    
                    let label = node.children[0] as SKLabelNode
                    
                    if (gameValue > 0)
                    {
                        label.text = (String)(gameValue)
                    }
                    else
                    {
                        label.text = ""
                    }
                    
                    node.color = colours[gameValue]
                }
            }
        }
        
        isDirty = false
        gameBoard.isGameBoardDirty = false
    }
}
