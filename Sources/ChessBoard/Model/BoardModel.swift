//
// BoardModel.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation

public class BoardModel : ObservableObject {
    @Published
    var pieces: [Piece] = []
    
    @Published
    var squareDecorations: [SquareDecoration] = []
    
    @Published
    var boardDecorations: [BoardDecoration] = []
    
    public init() {}
    
    // MARK: - Piece manipulation
    public func setupStartPosition() {
        pieces = [
            Piece(type: .pawn, color: .white, square: .a2),
            Piece(type: .pawn, color: .white, square: .b2),
            Piece(type: .pawn, color: .white, square: .c2),
            Piece(type: .pawn, color: .white, square: .d2),
            Piece(type: .pawn, color: .white, square: .e2),
            Piece(type: .pawn, color: .white, square: .f2),
            Piece(type: .pawn, color: .white, square: .g2),
            Piece(type: .pawn, color: .white, square: .h2),
            
            Piece(type: .rook, color: .white, square: .a1),
            Piece(type: .knight, color: .white, square: .b1),
            Piece(type: .bishop, color: .white, square: .c1),
            Piece(type: .queen, color: .white, square: .d1),
            Piece(type: .king, color: .white, square: .e1),
            Piece(type: .bishop, color: .white, square: .f1),
            Piece(type: .knight, color: .white, square: .g1),
            Piece(type: .rook, color: .white, square: .h1),
            
            Piece(type: .pawn, color: .black, square: .a7),
            Piece(type: .pawn, color: .black, square: .b7),
            Piece(type: .pawn, color: .black, square: .c7),
            Piece(type: .pawn, color: .black, square: .d7),
            Piece(type: .pawn, color: .black, square: .e7),
            Piece(type: .pawn, color: .black, square: .f7),
            Piece(type: .pawn, color: .black, square: .g7),
            Piece(type: .pawn, color: .black, square: .h7),
            
            Piece(type: .rook, color: .black, square: .a8),
            Piece(type: .knight, color: .black, square: .b8),
            Piece(type: .bishop, color: .black, square: .c8),
            Piece(type: .queen, color: .black, square: .d8),
            Piece(type: .king, color: .black, square: .e8),
            Piece(type: .bishop, color: .black, square: .f8),
            Piece(type: .knight, color: .black, square: .g8),
            Piece(type: .rook, color: .black, square: .h8),
        ]
    }
    
    /**
     Returns pieces.
     */
    public func allPieces() -> [Piece] {
        return self.pieces
    }
    
    /**
     Sets the piece collection.
     */
    public func set(pieces: [Piece]) {
        self.pieces = pieces
    }
    
    /**
     Returns the piece on a given square if any.
     */
    public func piece(on square: Square) -> Piece? {
        self.pieces.first {
            $0.square == square
        }
    }
    
    /**
     Removes all pieces.
     */
    public func removeAllPiece() {
        self.pieces = []
    }
    
    /**
     Places a piece on the board .
     Removes all existing pieces from `piece`'s square if any.
     */
    public func place(piece: Piece) {
        self.pieces = self.pieces.filter { $0.square != piece.square } + [piece]
    }
    
    /**
     Removes all pieces from a given square.
     */
    public func removePieces(from square: Square) {
        self.pieces = self.pieces.filter { $0.square != square }
    }
    
    /**
     Removes a given piece.
     */
    public func remove(piece: Piece) {
        self.pieces = self.pieces.filter { $0.id != piece.id }
    }
    
    /**
     Moves a piece to a given square.
     */
    public func move(piece: Piece, to square: Square) {
        removePieces(from: square)
        let newPiece = Piece(id: piece.id, type: piece.type, color: piece.color, square: square)
        self.pieces = self.pieces.filter { $0.id != piece.id } + [newPiece]
    }
    
    //MARK: - SquareDecoration manipulation
    
    /**
     Sets the square decorations.
     */
    public func set(squareDecorations: [SquareDecoration]) {
        self.squareDecorations = squareDecorations
    }
    
    /**
     Clears all square decorations.
     */
    public func removeAllSquareDecorations() {
        self.squareDecorations = []
    }
    
    /**
     Clears all square decorations from a given square.
     */
    public func removeAllDecorations(from square: Square) {
        self.squareDecorations = self.squareDecorations.filter {
            $0.square != square
        }
    }
    
    /**
     Adds a new square decoration.
     */
    public func add(squareDecoration: SquareDecoration, removeOthers: Bool = false) {
        if removeOthers {
            removeAllDecorations(from: squareDecoration.square)
        }
        self.squareDecorations += [squareDecoration]
    }
    
    // MARK: - Selections
    
    /**
     Returns all `SelectionSquareDecorations`
     */
    public func allSelections() -> [SelectionSquareDecoration] {
        self.squareDecorations.compactMap { $0 as? SelectionSquareDecoration }
    }
    
    /**
     Returns all selected squares.
     */
    public func selectedSquares() -> [Square] {
        Array(Set(self.allSelections().map { $0.square }))
    }
    
    /**
     Removes all selections.
     */
    public func removeAllSelections() {
        self.squareDecorations = self.squareDecorations.filter {
            !($0 is SelectionSquareDecoration)
        }
    }
    
    /**
     Returns if the given square is selected.
     */
    public func isSelected(square: Square) -> Bool {
        allSelections().contains { $0.square == square }
    }
    
    /**
     Selects a square (if it is not alredy selected).
     */
    public func select(square: Square) {
        guard !isSelected(square: square) else { return }
        self.squareDecorations += [SelectionSquareDecoration(square: square)]
    }
    
    /**
     Deselects a square (if it is selected).
     */
    public func deselect(square: Square) {
        guard isSelected(square: square) else { return }
        self.squareDecorations = self.squareDecorations.filter {
            guard let selection = $0 as? SelectionSquareDecoration else { return true }
            return selection.square != square
        }
    }
    
    /**
     Toggles selection on a given square.
     */
    public func toggleSelection(on square: Square) {
        if isSelected(square: square) {
            deselect(square: square)
        } else {
            select(square: square)
        }
    }
    
    // MARK: - Highlight manipulation
    
    /**
     Returns all highlights.
     */
    public func allHighlights() -> [HighlightSquareDecoration] {
        self.squareDecorations.compactMap { $0 as? HighlightSquareDecoration }
    }
    
    /**
     Returns all highlights of a given type.
     */
    public func allHighlights(ofType type: HighlightSquareDecoration.DecorationType) -> [HighlightSquareDecoration] {
        self.squareDecorations
            .compactMap { $0 as? HighlightSquareDecoration }
            .filter { $0.type == type }
    }
    
    /**
     Returns highlights on a given square.
     */
    public func highlights(on square: Square) -> [HighlightSquareDecoration] {
        allHighlights().filter {
            $0.square == square
        }
    }
    
    /**
     Removes all highlights.
     */
    public func removeAllHighlights() {
        self.squareDecorations = self.squareDecorations.filter {
            !($0 is HighlightSquareDecoration)
        }
    }
    
    /**
     Removes all highlights of a given type.
     */
    public func removeAllHighlights(ofType type: HighlightSquareDecoration.DecorationType) {
        self.squareDecorations = self.squareDecorations.filter {
            guard let highlight = $0 as? HighlightSquareDecoration else { return true }
            return highlight.type != type
        }
    }
    
    /**
     Removes all highlights from a square.
     */
    public func removeHighlights(from square: Square) {
        self.squareDecorations = self.squareDecorations.filter {
            guard let highlight = $0 as? HighlightSquareDecoration else { return true }
            return highlight.square != square
        }
    }

    /**
     Removes all highlights with given type from a square.
     */
    public func removeHighlights(from square: Square, type: HighlightSquareDecoration.DecorationType) {
        self.squareDecorations = self.squareDecorations.filter {
            guard let highlight = $0 as? HighlightSquareDecoration else { return true }
            return highlight.square != square || highlight.type != type
        }
    }

    /**
     Highlights a cell.
     */
    public func addHighlight(ofType type: HighlightSquareDecoration.DecorationType, to square: Square, removeOthers:Bool = false) {
        if removeOthers {
            removeHighlights(from: square)
        }
        self.squareDecorations += [HighlightSquareDecoration(square: square, type: type)]
    }
    
    /**
     If there is a highlight with the given type on that square then turns it off, otherwise adds a new highlight.
     */
    public func toggleHighlight(ofType type: HighlightSquareDecoration.DecorationType, on square: Square, removeOthers:Bool = false) {
        if highlights(on: square).contains(where: { $0.type == type }) {
            removeHighlights(from: square, type: type)
            return
        }
        addHighlight(ofType: type, to: square, removeOthers: removeOthers)
    }

    // MARK: - Board decoration manipulation
    
    /**
     Returns the collection of board decorators.
     */
    public func allBoardDecorations() -> [BoardDecoration] {
        return self.boardDecorations
    }
    
    /**
     Replaces teh currect board decorations.
     */
    public func set(boardDecorations: [BoardDecoration]) {
        self.boardDecorations = boardDecorations
    }
    
    /**
     Removes all board decoration.
     */
    public func removeAllBoardDecorations() {
        self.boardDecorations = []
    }
    
    // MARK: - Arrow manipulations
    
    /**
     Returns all arrows.
     */
    public func allArrows() -> [Arrow] {
        self.boardDecorations.compactMap { $0 as? Arrow }
    }
    
    /**
     Returns all arrows from a given square.
     */
    public func allArrows(from square: Square) -> [Arrow] {
        allArrows().filter { $0.start == square }
    }
    
    /**
     Returns all arrows to a given square.
     */
    public func allArrows(to square: Square) -> [Arrow] {
        allArrows().filter { $0.end == square }
    }
    
    /**
     Returns all arrows between to given squares,
     */
    public func allArrows(from start:Square, to end: Square) -> [Arrow] {
        allArrows().filter { $0.start == start && $0.end == end }
    }
    
    /**
     Adds an arrow with given type between two squares.
     */
    public func addArrow(type: Arrow.DecorationType, from start: Square, to end: Square, removeOthers: Bool = false) {
        if removeOthers {
            removeArrows(from: start, to: end)
        }
        self.boardDecorations += [Arrow(type: type, start: start, end: end)]
    }
    
    /**
     If there is an arrow with the same type between the two given squares then removes it, otherwise adds a new one.
     */
    public func toggleArrow(type: Arrow.DecorationType, from start: Square, to end: Square, removeOthers: Bool = false) {
        if allArrows(from: start, to: end).contains(where: { $0.type == type }) {
            removeArrows(type: type, from: start, to: end)
            return
        }
        addArrow(type: type, from: start, to: end, removeOthers: removeOthers)
    }
    
    /**
     Removes all arrows.
     */
    public func removeArrows() {
        self.boardDecorations = self.boardDecorations.filter {
            !($0 is Arrow)
        }
    }

    /**
     Removes all arrows between two squares.
     */
    public func removeArrows(from start:Square, to end: Square) {
        self.boardDecorations = self.boardDecorations.filter {
            guard let arrow = $0 as? Arrow else {
                return true
            }
            return arrow.start != start || arrow.end != end
        }
    }
    
    /**
     Removes all arrows between two squares with the given type.
     */
    public func removeArrows(type: Arrow.DecorationType, from start:Square, to end: Square) {
        self.boardDecorations = self.boardDecorations.filter {
            guard let arrow = $0 as? Arrow else {
                return true
            }
            return arrow.type != type || arrow.start != start || arrow.end != end
        }
    }
}

