//
// BoardGeometry.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation

public class BoardGeometry : ObservableObject {
    @Published
    var size: CGFloat
    
    var cellSize: CGFloat {
        size / 8
    }
    
    @Published
    var flipped: Bool = false
    
    init(size: CGFloat, flipped: Bool = false) {
        self.size = size
        self.flipped = flipped
    }
    
    func cellFrame(square: Square) -> CGRect {
        let file = square.file.rawValue
        let rank = square.rank.rawValue
        
        let x = flipped ? (CGFloat(7 - file) * cellSize) : CGFloat(file) * cellSize
        let y = flipped ? CGFloat(rank) * cellSize : CGFloat(7 - rank) * cellSize
        return CGRect(x: x, y: y, width: cellSize, height: cellSize)
    }
    
    func squareForPosition(position: CGPoint) -> Square? {
        let ix = Int(position.x / cellSize)
        let iy = Int(position.y / cellSize)
        
        if ix < 0 || ix > 7 {
            return nil
        }
        if iy < 0 || iy > 7 {
            return nil
        }
        if flipped {
            return Square(x: 7 - ix, y: iy)
        } else {
            return Square(x: ix, y: 7 - iy)
        }
    }
}
