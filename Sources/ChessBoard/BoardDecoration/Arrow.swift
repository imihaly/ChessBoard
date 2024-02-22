//
// Arrow.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation

public class Arrow: BoardDecoration {
    public enum DecorationType {
        case red // click without modifiers
        case green // click + shift
        case orange // click + cmd
        case blue // click + option
    }
    
    public var type: DecorationType
    public var start: Square
    public var end: Square
    
    public init(id: UUID = UUID(), type: DecorationType, start: Square, end: Square) {
        self.type = type
        self.start = start
        self.end = end
        super.init(id: id)
    }
}
