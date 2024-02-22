//
// SquareSet.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import SwiftUI

public protocol SquareSet {
    func squareView(square: Square, geometry: BoardGeometry) -> AnyView
}

