//
// Piece.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation
import CoreTransferable

public struct Piece: Identifiable, Codable
{
    public enum PieceType: Int32, Codable, CaseIterable {
        case pawn
        case rook
        case knight
        case bishop
        case queen
        case king
    }
    
    public enum PieceColor: Int32, Codable, CaseIterable {
        case white
        case black
    }
    
    public var id = UUID()
    public var type: PieceType
    public var color: PieceColor
    public var square: Square
}

