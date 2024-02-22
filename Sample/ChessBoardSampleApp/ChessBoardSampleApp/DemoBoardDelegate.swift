//
// DemoBoardDelegate.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation
import ChessBoard

class DemoBoardDelegate: BoardDelegate {
    var model: BoardModel
    var decorationMode = false
    
    init(model: BoardModel) {
        self.model = model
    }
    
    /**
     While dragging a pice the selects the original and the target square.
     */
    func pieceDragging(piece: Piece, square: Square?) {
        model.removeAllSelections()
        model.select(square: piece.square)
        if let square = square {
            model.select(square: square)
        }
    }
    
    /**
     If a piece waas dragged outside of the board it will be removed otherwise moved to the target square.
     */
    func pieceDragged(piece: Piece, square: Square?) {
        model.removeAllSquareDecorations()
        model.removeAllBoardDecorations()
        
        if let square = square {
            model.move(piece: piece, to: square)
        } else {
            model.remove(piece: piece)
        }
    }
    
    /**
     If there is no square selected yet selects the tapped square.
     if there is a square selected:
        - if no piece on that square, then the selection will be moved to the new square
        - if there is a piece on the selected square then it will be moved to the new square
     */
    func tapped(square: Square) {
        if decorationMode {
            model.toggleHighlight(ofType: .red, on: square, removeOthers: true)
            return
        }
        
        let selectedSquares = model.selectedSquares()
        if selectedSquares.isEmpty {
            model.removeAllSelections()
            model.select(square: square)
        } else {
            let selectedSquare = selectedSquares.first!
            if selectedSquare == square {
                model.deselect(square: square)
            } else {
                if let piece = model.piece(on: selectedSquare) {
                    model.move(piece: piece, to: square)
                    model.removeAllBoardDecorations()
                    model.removeAllSquareDecorations()
                } else {
                    model.removeAllSelections()
                    model.select(square: square)
                }
            }
        }
    }
    
    func canDragPiece(piece: Piece) -> Bool {
        !decorationMode
    }
    
    func onDragging(from: Square?, to: Square?) {
        guard decorationMode else { return }
    }
    
    func onDragged(from: Square?, to: Square?) {
        guard decorationMode else { return }
        guard let start = from, let end = to, start != end else { return }
        
        model.toggleArrow(type: .red, from: start, to: end, removeOthers: true)
    }
    
    /**
     Adds/removes a highlight to/from a square.
     */
    func onRightMouseClick(square: Square?, modifiers: Modifiers) {
        guard let square = square else {
            return
        }
        
        var decorationType = HighlightSquareDecoration.DecorationType.red
        if modifiers.contains(.shift) {
            decorationType = .green
        } else if modifiers.contains(.control) {
            decorationType = .orange
        } else if modifiers.contains(.option) {
            decorationType = .blue
        }
        
        model.toggleHighlight(ofType: decorationType, on: square, removeOthers: true)
    }
    
    /**
     Adds/removes an arrow between two squares.
     */
    func onRightMouseDragged(from: Square?, to: Square?, modifiers: Modifiers) {
        guard let from = from, let to = to, from != to else {
            return
        }
        
        var decorationType = Arrow.DecorationType.red
        if modifiers.contains(.shift) {
            decorationType = .green
        } else if modifiers.contains(.control) {
            decorationType = .orange
        } else if modifiers.contains(.option) {
            decorationType = .blue
        }
        
        model.toggleArrow(type: decorationType, from: from, to: to, removeOthers:  true)
    }
    
}
