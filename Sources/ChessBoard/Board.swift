//
// Board.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import SwiftUI

public struct Board: View {
    public class Configuration : ObservableObject {
        @Published
        public var flipped: Bool = false
        
        @Published
        public var showCoordinates: Bool = false
        
        @Published
        public var coordinatesSize = 20.0
        
        @Published
        public var coordinatesFont = Font.system(size: 16, weight: .bold)

        @Published
        public var coordinatesBackgroundColor = Color.black

        @Published
        public var coordinatesForegroundColor = Color.white

        @Published
        public var squareSet: any SquareSet = GreenSquareSet()
        
        @Published
        public var pieceSet: any PieceSet = CBurnettPieceSet()
        
        @Published
        public var squareDecorator: any SquareDecorator = DefaultSquareDecorator()
        
        @Published
        public var boardDecorator: any BoardDecorator = ArrowBoardDecorator()
        
        public init() {}
    }

    
    @StateObject
    var configuration = Configuration()
        
    @ObservedObject
    var model: BoardModel
    
    weak var delegate: (any BoardDelegate)? = nil
    
    @State
    var boardGeometry: BoardGeometry = BoardGeometry(size: 100)
    
    public init(model: BoardModel, configuration: Configuration = Configuration(), delegate: (any BoardDelegate)? = nil) {
        _configuration = StateObject(wrappedValue: configuration)
        self.model = model
        self.delegate = delegate
    }

    @ViewBuilder
    public var body: some View {
        
        GeometryReader { geometry in
            let totalSize = min(geometry.size.width, geometry.size.height)
            let boardSize = totalSize - (configuration.showCoordinates ? configuration.coordinatesSize : 0.0)

            let boardGeometry = BoardGeometry(size: boardSize, flipped: configuration.flipped)
            let cellSize = boardGeometry.cellSize
            HStack(spacing: 0) {
                if configuration.showCoordinates {
                    VStack(spacing: 0) {
                        ForEach(1...8, id: \.self) { rank in
                            Text("\(configuration.flipped ? rank : 9 - rank)")
                                .frame(width: configuration.coordinatesSize, height: cellSize)
                                .font(configuration.coordinatesFont)
                                .foregroundColor(configuration.coordinatesForegroundColor)
                                .background {
                                    configuration.coordinatesBackgroundColor
                                }
                        }
                        Spacer()
                            .frame(width: configuration.coordinatesSize, height: configuration.coordinatesSize)
                            .background {
                                configuration.coordinatesBackgroundColor
                            }
                    }
                }
                VStack(spacing: 0) {
                    Content(configuration: configuration,
                            model: model,
                            delegate: delegate)
                    .nsEvents(
                        onRightMouseDown: { location, modifiers in
                            delegate?.onRightMouseDown(square: boardGeometry.squareForPosition(position: location), modifiers: modifiers)
                        },
                        onRightMouseUp: { location, modifiers in
                            delegate?.onRightMouseUp(square: boardGeometry.squareForPosition(position: location), modifiers: modifiers)
                        },
                        onRightMouseClick: { location, modifiers in
                            delegate?.onRightMouseClick(square: boardGeometry.squareForPosition(position: location), modifiers: modifiers)
                        },
                        onRightMouseDragged: { start, end, modifiers in
                            delegate?.onRightMouseDragged(from: boardGeometry.squareForPosition(position: start),
                                                          to: boardGeometry.squareForPosition(position: end),
                                                          modifiers: modifiers)
                        }
                    )
                    .frame(width: boardSize, height: boardSize)
                    
                    if configuration.showCoordinates {
                        HStack(spacing: 0) {
                            ForEach(1...8, id: \.self) { file in
                                Text("\(File(rawValue: configuration.flipped ? 8 - file : file - 1)!.name)")
                                    .frame(width: cellSize, height: configuration.coordinatesSize)
                                    .font(configuration.coordinatesFont)
                                    .foregroundColor(configuration.coordinatesForegroundColor)
                                    .background {
                                        configuration.coordinatesBackgroundColor
                                    }
                            }
                        }
                    }
                }
            }
        }
        .aspectRatio(contentMode: .fit)
    }
    

    private struct Content: View {
        
        @ObservedObject
        var configuration: Board.Configuration
        
        // drag and drop
        @State
        var draggedPiece: Piece? = nil
        
        @State
        var dragOffset: CGSize = CGSizeZero
        
        @ObservedObject
        var model: BoardModel
        
        weak var delegate: (any BoardDelegate)? = nil
        
        @ViewBuilder
        var body: some View {
            
            GeometryReader { geometry in
                let boardSize = min(geometry.size.width, geometry.size.height)
                let boardGeometry = BoardGeometry(size: boardSize, flipped: configuration.flipped)
                
                ZStack {
                    Group {
                        
                        // draw squares
                        ForEach(0...7, id: \.self) { file in
                            ForEach(0...7, id: \.self) { rank in
                                let square = Square(x: file, y: rank)!
                                let frame = boardGeometry.cellFrame(square: square)
                                configuration.squareSet.squareView(square: square, geometry: boardGeometry)
                                    .frame(width: frame.size.width, height: frame.size.height)
                                    .position(x: frame.center.x, y: frame.center.y)
                                    .simultaneousGesture(
                                        TapGesture()
                                            .onEnded{ _ in
                                                delegate?.tapped(square: square)
                                            }
                                    )
                                    .gesture(
                                        DragGesture()
                                            .onChanged({ gesture in
                                                let end = boardGeometry.squareForPosition(position: gesture.location)
                                                delegate?.onDragging(from: square, to: end)
                                            })
                                            .onEnded({ gesture in
                                                let end = boardGeometry.squareForPosition(position: gesture.location)
                                                delegate?.onDragged(from: square, to: end)
                                            })
                                    )
                            }
                        }
                        
                        // draw square decorations
                        ForEach(model.squareDecorations) { decoration in
                            let frame = boardGeometry.cellFrame(square: decoration.square)
                            configuration.squareDecorator.view(for: decoration)
                                .frame(width: frame.size.width, height: frame.size.height)
                                .position(x: frame.center.x, y: frame.center.y)
                        }
                        
                        // draw pieces
                        ForEach(model.pieces) { piece in
                            let frame = boardGeometry.cellFrame(square: piece.square)
                            pieceView(piece: piece, frame: frame, boardGeometry: boardGeometry)
                                .zIndex(piece.id == draggedPiece?.id ? 1 : 0)
                        }
                        
                        // draw board decorations
                        ForEach(model.boardDecorations) { decoration in
                            configuration.boardDecorator.view(for: decoration, geometry: boardGeometry)
                        }
                        
                    } // Group
                } // ZStack
                .onDrop(of: [ChessUTI], delegate: BoardDropDelegate(model: model, boardGeometry: boardGeometry))
            }
        }
        
        @ViewBuilder
        private func pieceView(piece: Piece, frame: CGRect, boardGeometry: BoardGeometry) -> some View {
            configuration.pieceSet.pieceView(type: piece.type, color: piece.color)
                .frame(width: frame.size.width, height: frame.size.height)
                .position(x: frame.center.x, y: frame.center.y)
                .offset(piece.id == draggedPiece?.id ? dragOffset : CGSizeZero)
                .gesture(DragGesture()
                    .onChanged{ gesture in
                        guard delegate?.canDragPiece(piece: piece) ?? false else {
                            let square = boardGeometry.squareForPosition(position: gesture.location)
                            delegate?.onDragging(from: piece.square, to: square)
                            return
                        }
                        draggedPiece = piece
                        dragOffset = gesture.translation
                        let square = boardGeometry.squareForPosition(position: gesture.location)
                        delegate?.pieceDragging(piece: piece, square: square)
                    }
                    .onEnded { gesture in
                        guard delegate?.canDragPiece(piece: piece) ?? false else {
                            let square = boardGeometry.squareForPosition(position: gesture.location)
                            delegate?.onDragged(from: piece.square, to: square)
                            return
                        }
                        withAnimation(.easeInOut(duration: 0.1)) {
                            let square = boardGeometry.squareForPosition(position: gesture.location)
                            delegate?.pieceDragged(piece: piece, square: square)
                            
                            draggedPiece = nil
                            dragOffset = CGSizeZero
                        }
                    }
                )
                .gesture(
                    TapGesture()
                        .onEnded{ _ in
                            delegate?.tapped(square: piece.square)
                        }
                )
        }
    }

}

struct Board_Previews: PreviewProvider {
    static var previews: some View {
        Board(model: BoardModel())
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
}
