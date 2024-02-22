//
// BoardDelegate.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation

public protocol BoardDelegate : AnyObject {
    // piece
    func canDragPiece(piece: Piece) -> Bool
    func pieceDragging(piece: Piece, square: Square?)
    func pieceDragged(piece: Piece, square: Square?)
    
    // tap
    func tapped(square: Square)
    
    // drag
    func onDragging(from: Square?, to: Square?)
    func onDragged(from: Square?, to: Square?)

    // right mouse
    func onRightMouseDown(square: Square?, modifiers: Modifiers)
    func onRightMouseUp(square: Square?, modifiers: Modifiers)
    func onRightMouseClick(square: Square?, modifiers: Modifiers)
    func onRightMouseDragging(from: Square?, to: Square?, modifiers: Modifiers)
    func onRightMouseDragged(from: Square?, to: Square?, modifiers: Modifiers)
}

public extension BoardDelegate {
    // piece
    func canDragPiece(piece: Piece) -> Bool { true }
    func pieceDragging(piece: Piece, square: Square?) {}
    func pieceDragged(piece: Piece, square: Square?) {}
    
    // tap
    func tapped(square: Square) {}
    
    // drag
    func onDragging(from: Square?, to: Square?) {}
    func onDragged(from: Square?, to: Square?) {}
    
    // right mouse
    func onRightMouseDown(square: Square?, modifiers: Modifiers) {}
    func onRightMouseUp(square: Square?, modifiers: Modifiers) {}
    func onRightMouseClick(square: Square?, modifiers: Modifiers) {}
    func onRightMouseDragging(from: Square?, to: Square?, modifiers: Modifiers) {}
    func onRightMouseDragged(from: Square?, to: Square?, modifiers: Modifiers) {}
}
