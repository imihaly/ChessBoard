//
// PieceSet.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import SwiftUI

public protocol PieceSet {
    func pieceView(type: Piece.PieceType, color: Piece.PieceColor) -> AnyView
}
