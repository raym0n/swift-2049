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
    var backgroundNode:SKSpriteNode = SKSpriteNode()
    
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
        backgroundNode = SKSpriteNode()
        backgroundNode.size = CGSize(width: gridWidth, height: gridHeight)
        backgroundNode.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundNode.zPosition = -1
        backgroundNode.position = CGPoint(x: 0, y: 50)
        backgroundNode.color = UIColor(red: 0.95, green: 0.69, blue: 0.41, alpha: 0.5)
        backgroundNode.name = "background"
        self.addChild(backgroundNode)
        
        for y in 0..gameBoard.numRows {
            for x in 0..gameBoard.numCols {
                let tile = SKSpriteNode()
                tile.position = CGPoint(x:  (x * blockWidth) + spaceBetweenBlocks * (x+1),  y: (y * blockHeight) + spaceBetweenBlocks * (y+1))
                tile.anchorPoint = CGPoint(x: 0, y: 0)

                tile.size = CGSize(width: blockWidth, height: blockHeight)
                tile.zPosition = 0
                tile.name = "node: \(x)_\(y)"
                
                backgroundNode.addChild(tile)
                
                let gameValue = gameBoard.getValue(x, y: y);
                let label = addLabel(gameValue == 0 ? "" : (String)(gameValue))
               
                tile.color = colours[gameValue]
                
                tile.addChild(label)
            }
        }
        
        let undo = addUndoButton()
        let start = addStartButton()
        let heading = addHeading()
        let footer = addFooter()
        
        self.addChild(undo)
        self.addChild(start)
        self.addChild(heading)
        self.addChild(footer)
        
        isDirty = true
    }
    
    
    func addHeading() -> SKSpriteNode {
        let node = SKSpriteNode()
        node.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 80)
        node.name = "heading"
        
        let label = SKLabelNode()
        label.text = "Swift - 2048"
        label.fontName = "Zapfino"
        label.fontColor = UIColor.blackColor()
        label.fontSize = 20
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.zPosition = 1
        label.position = CGPoint(x: node.centerRect.width/2, y: node.centerRect.height/2)
        
        node.addChild(label)
        return node
    }
    
    
    func addFooter() -> SKSpriteNode {
        let node = SKSpriteNode()
        node.position = CGPoint(x: self.frame.width/2, y: 20)
        node.name = "footer"
        
        let label = SKLabelNode()
        label.text = "Score: 0"
        label.fontName = "HelveticaNeue-Medium"
        label.fontColor = UIColor.blackColor()
        label.fontSize = 14
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.zPosition = 1
        label.position = CGPoint(x: node.centerRect.width/2, y: node.centerRect.height/2)
        
        node.addChild(label)
        return node
    }
    
    func addStartButton() -> SKSpriteNode {
        let texture = SKTexture(imageNamed: "Start.png")
        texture.filteringMode = SKTextureFilteringMode.Nearest
        
        let node = SKSpriteNode(texture: texture)
        node.setScale(0.4)
        node.position = CGPoint(x: 80, y: self.frame.height - 150)
        node.name = "start"
        
        let label = SKLabelNode()
        label.text = "Restart Game"
        label.fontName = "HelveticaNeue-Medium"
        label.fontColor = UIColor.whiteColor()
        label.fontSize = 40
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.zPosition = 1
        label.position = CGPoint(x: node.centerRect.width/2, y: node.centerRect.height/2)
        
        node.addChild(label)
        return node
    }
    
    func addUndoButton() -> SKSpriteNode {
        let texture = SKTexture(imageNamed: "Undo.png")
        texture.filteringMode = SKTextureFilteringMode.Nearest
        
        let node = SKSpriteNode(texture: texture)
        node.setScale(0.4)
        node.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 150)
        node.alpha = 0.5
        node.name = "undo"

        let label = SKLabelNode()
        label.text = "Undo Move"
        label.fontName = "HelveticaNeue-Medium"
        label.fontColor = UIColor.whiteColor()
        label.fontSize = 40
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.zPosition = 1
        label.position = CGPoint(x: node.centerRect.width/2, y: node.centerRect.height/2)
        
        
        node.addChild(label)
        return node
    }
    
    func addLabel(label: String) -> SKLabelNode {
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
        
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        if var node = self.nodeAtPoint(location) {
            
            if node is SKLabelNode {
                node = node.parent! as SKSpriteNode
            }
            
            if (node is SKSpriteNode) {
                if node == backgroundNode {
                    return
                }
                
                if node.name == "undo" {
                    gameBoard.performUndo()
                    isDirty = true
                    return
                }
                
                if node.name == "start" {
                    gameBoard.startGame()
                    isDirty = true
                    return
                }
                
                if (gameBoard.isGameOver().0 == false) //game over false
                {
                    let colour = SKAction.fadeAlphaTo(0.5, duration: 0)
                    node.runAction(colour)
                    selectedNode = node
                }
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
                    if node == backgroundNode || node.name! == "start" || node.name! == "undo" {
                        return
                    }
                    
                    let colour = SKAction.fadeAlphaTo(0.5, duration: 0)
                    node.runAction(colour)
                }
            }
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        
        if var node = (self.nodeAtPoint(location)) {
            if (node is SKLabelNode) {
                node = node.parent as SKSpriteNode
            }
            
            if (gameBoard.isGameOver().0 == false)
            {
                if (selectedNode != nil && node is SKSpriteNode)
                {
                    let swipeHorizontal = selectedNode!.position.x - node.position.x
                    let swipeVertical = selectedNode!.position.y - node.position.y
                    
                    swipeDirection.updateSwipe((Int)(swipeHorizontal), y: (Int)(swipeVertical))
                    gameBoard.performSwipe(swipeDirection)
                    
                    isDirty = true
                    selectedNode = nil
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        let gameOver = gameBoard.isGameOver()
        
        if (gameOver.0 == true)
        {
            let footer = self.children.filter { $0.name? == "footer" }
            let label = (footer[0] as SKSpriteNode).children[0] as SKLabelNode
            
            if gameOver.1 == GameStatus.Won {
                label.text = "You Won!!! Final Score: \(gameBoard.score)"
            } else {
                label.text = "Game Over Man! Final Score: \(gameBoard.score)"
            }
        }
        
        if (isDirty)
        {
            let background = (self.children.filter { $0.name? == "background" })
            let nodes = (background[0] as SKSpriteNode).children
            
            for y in 0..gameBoard.numRows {
                for x in 0..gameBoard.numCols {
                    
                    let gameValue = gameBoard.getValue(x, y: y);
                    let position = ((x) % gameBoard.numCols) + ((gameBoard.numRows - y - 1) * gameBoard.numRows)
                    let node = nodes[position] as SKSpriteNode
                    
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
            
            let undo = self.children.filter { $0.name? == "undo" }
            (undo[0] as SKSpriteNode).alpha = gameBoard.canUndo ? 1.0 : 0.5
            
            let footer = self.children.filter { $0.name? == "footer" }
            let label = (footer[0] as SKSpriteNode).children[0] as SKLabelNode
            label.text = "Score: \(gameBoard.score)"
        }
        
        isDirty = false
        gameBoard.isGameBoardDirty = false
    }
}
