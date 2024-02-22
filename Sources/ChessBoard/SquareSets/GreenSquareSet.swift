//
// GreenSquareSet.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation
import SwiftUI

public class GreenSquareSet: SquareSet {
    let darkColor = Color("GB_Dark", bundle: Bundle.module)
    let brightColor = Color("GB_Light", bundle: Bundle.module)
    
    public init() {}
    
    public func squareView(square: Square, geometry: BoardGeometry) -> AnyView {        
        let color = (square.file.rawValue + square.rank.rawValue) % 2 == 0 ?  darkColor : brightColor
        return AnyView(color)
    }
}

