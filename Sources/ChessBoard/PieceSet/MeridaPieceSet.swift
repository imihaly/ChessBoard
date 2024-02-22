//
// MeridaPieceSet.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation
import SwiftUI

public class MeridaPieceSet: PieceSet {
    
    public init() {}
    
    public func pieceView(type: Piece.PieceType, color: Piece.PieceColor) -> AnyView {
        var imageName = "M_"
        
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
