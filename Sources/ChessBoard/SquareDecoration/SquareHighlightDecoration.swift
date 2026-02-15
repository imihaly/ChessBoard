//
// SquareHighlightDecoration.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation

/// A SquareDecoration designed to mark highlighted squares.
public class HighlightSquareDecoration: SquareDecoration {
    public enum DecorationType {
        case red // click without modifiers
        case green // click + shift
        case orange // click + cmd
        case blue // click + option
    }
    
    var type: DecorationType
    
    public init(square: Square, type: DecorationType) {
        self.type = type
        super.init(square: square)
    }
}
