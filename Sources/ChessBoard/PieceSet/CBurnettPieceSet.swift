//
// CBurnettPieceSet.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation
import SwiftUI

// A piece set using CBurnett's pieces:
// https://meta.wikimedia.org/wiki/Talk:WikiProject_Chess
public
class CBurnettPieceSet: PieceSet {

    public init() {}

    public func pieceView(type: Piece.PieceType, color: Piece.PieceColor) -> AnyView {
        var imageName = "CB_"
        
        switch color {
        case .white:
            imageName += "w"
        case .black:
            imageName += "b"
        }
        
        switch type {
        case .pawn:
            imageName += "P"
        case .rook:
            imageName += "R"
        case .knight:
            imageName += "N"
        case .bishop:
            imageName += "B"
        case .queen:
            imageName += "Q"
        case .king:
            imageName += "K"
        }
        
        return AnyView(
            Image(imageName, bundle: Bundle.module)
                .resizable()
        )
    }
}
