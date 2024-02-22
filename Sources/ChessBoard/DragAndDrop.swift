//
// DragAndDrop.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation
import UniformTypeIdentifiers
import SwiftUI

let ChessUTI: String = UTType.item.identifier

public final class PieceData: NSObject, NSItemProviderWriting, NSItemProviderReading, Codable {
    public static var readableTypeIdentifiersForItemProvider: [String] = [ChessUTI]
    public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        let jsonDecoder = JSONDecoder()
        let item = try! jsonDecoder.decode(Self.self, from: data)
        return item
    }
    
    public enum Oops: Error {
        case invalidTypeIdentifier
    }
    
    public static var writableTypeIdentifiersForItemProvider: [String] = [ChessUTI]
    
    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        guard typeIdentifier == ChessUTI else {
            completionHandler(nil, Oops.invalidTypeIdentifier)
            return progress
        }
        do {
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(self)
            completionHandler(data, nil)
        }
        catch { completionHandler(nil, error) }
        return progress
    }
    
    let pieceType: Piece.PieceType
    let pieceColor: Piece.PieceColor
    
    public init(pieceType: Piece.PieceType, pieceColor: Piece.PieceColor) {
        self.pieceType = pieceType
        self.pieceColor = pieceColor
    }
}

struct BoardDropDelegate: DropDelegate {
    let model: BoardModel
    let boardGeometry: BoardGeometry
    
    func performDrop(info: DropInfo) -> Bool {
        guard let square = boardGeometry.squareForPosition(position: info.location) else {
            return false
        }
        let items = info.itemProviders(for: [ChessUTI])
        for item in items {
            _ = item.loadObject(ofClass: PieceData.self) { item, _ in
                if let item = item as? PieceData {
                    let piece = Piece(type: item.pieceType, color: item.pieceColor, square: square)
                    DispatchQueue.main.async {
                        model.place(piece: piece)
                    }
                }
            }
        }
        return true
    }
}

