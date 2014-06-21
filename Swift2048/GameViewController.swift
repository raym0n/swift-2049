//
//  GameViewController.swift
//  Swift2048
//
//  Created by Peter Sbarski on 17/06/2014.
//  Copyright (c) 2014 Peter Sbarski. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet var skView : SKView = nil
    var scene: GameScene!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        scene = GameScene(sceneSize: self.skView.bounds.size)
        self.skView.showsFPS = true
        self.skView.showsNodeCount = true
        self.skView.ignoresSiblingOrder = true
        
        self.skView.presentScene(scene)
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
