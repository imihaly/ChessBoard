//
// SquareDecoration.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation

public class SquareDecoration: Identifiable {
    
    public var id = UUID()
    var square: Square
    
    public init(square: Square) {
        self.square = square
    }
}
