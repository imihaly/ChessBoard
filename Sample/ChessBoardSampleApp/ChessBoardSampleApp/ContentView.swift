//
// ContentView.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import SwiftUI
import ChessBoard

struct ContentView: View {
    var model: BoardModel
    var delegate : DemoBoardDelegate
    
    @StateObject
    var config = Board.Configuration()
    
    init() {
        self.model = BoardModel()
        self.model.setupStartPosition()
        self.delegate = DemoBoardDelegate(model: model)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                Board(model: model, configuration: config, delegate: delegate)
                    .padding()
                Spacer()
            }
            
            VStack {
                ForEach(Piece.PieceType.allCases, id: \.self) { pieceType in
                    HStack {
                        config.pieceSet.pieceView(type: pieceType, color: .white)
                            .frame(width: 80, height: 80)
                            .onDrag {
                                NSItemProvider(object: PieceData(pieceType: pieceType, pieceColor: .white))
                            }

                        config.pieceSet.pieceView(type: pieceType, color: .black)
                            .frame(width: 80, height: 80)
                            .onDrag {
                                NSItemProvider(object: PieceData(pieceType: pieceType, pieceColor: .black))
                            }
                    }
                }
                Spacer()
            }
            
            // options
            VStack(alignment: .leading) {
                Button {
                    config.flipped.toggle()
                } label: {
                    HStack {
                        Text("Flip Table")
                        Spacer()
                    }
                }
                .padding()
                
                Button {
                    if config.squareSet is BlueSquareSet {
                        config.squareSet = GreenSquareSet()
                    } else {
                        config.squareSet = BlueSquareSet()
                    }
                } label: {
                    HStack {
                        Text("Toggle square set")
                        Spacer()
                    }
                }
                .padding()

                Button {
                    if config.pieceSet is CBurnettPieceSet {
                        config.pieceSet = MeridaPieceSet()
                    } else {
                        config.pieceSet = CBurnettPieceSet()
                    }
                } label: {
                    HStack {
                        Text("Toggle piece set")
                        Spacer()
                    }
                }
                .padding()

                Button {
                    config.showCoordinates.toggle()
                } label: {
                    HStack {
                        Text("Toggle coordinates")
                        Spacer()
                    }
                }
                .padding()

                #if os(iOS)
                Button {
                    delegate.decorationMode.toggle()
                } label: {
                    HStack {
                        Text("Toggle mode")
                        Spacer()
                    }
                }
                .padding()

                #endif
                Spacer()
            }
            .frame(width: 200.0)
            .padding()
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
