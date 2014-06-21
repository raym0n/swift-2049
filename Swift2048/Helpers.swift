//
//  Helpers.swift
//  Swift2048
//
//  Created by Peter Sbarski on 17/06/2014.
//  Copyright (c) 2014 Peter Sbarski. All rights reserved.
//

import Foundation

operator infix |> {
    associativity left
}

operator infix <| {
    associativity right
}

func |> <L, R>(left: L, right: L -> R) -> R {
    return right(left)
}

func <| <L, R>(left: R -> L, right: R) -> L {
    return left(right)
}

enum Swipe : Printable {
    case None, Left, Right, Up, Down
    
    mutating func updateSwipe(x: Int, y: Int){
        
        if (abs(x) < 40 && abs(y) < 40) {
            self = None
            return
        }
        
        if abs(x) > abs(y)
        {
            self = x < 0 ? Right : Left
        }
        else
        {
            self = y < 0 ? Up : Down
        }
    }
    
    var description: String {
    switch self {
    case .None:
        return "None"
    case .Left:
        return "Left"
    case .Right:
        return "Right"
    case .Up:
        return "Up"
    case .Down:
        return "Down"
        }
    }
}