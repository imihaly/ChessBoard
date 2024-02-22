//
// Square.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation

enum File: Int, Codable, Hashable {
    case _A = 0
    case _B = 1
    case _C = 2
    case _D = 3
    case _E = 4
    case _F = 5
    case _G = 6
    case _H = 7
    
    var name: String {
        ["a", "b", "c", "d", "e", "f", "g", "h"][self.rawValue]
    }
}

enum Rank: Int, Codable, Hashable {
    case _1 = 0
    case _2 = 1
    case _3 = 2
    case _4 = 3
    case _5 = 4
    case _6 = 5
    case _7 = 6
    case _8 = 7
    
    var name: String {
        "\(rawValue + 1)"
    }
}

public struct Square : Equatable, Codable, Hashable {
    
    var description: String {
        file.name + rank.name
    }
    
    let file: File
    let rank: Rank
    
    init(file: File, rank: Rank) {
        self.file = file
        self.rank = rank
    }
    
    init?(x: Int, y: Int) {
        guard let file = File(rawValue: x), let rank = Rank(rawValue: y) else {
            return nil
        }
        
        self.file = file
        self.rank = rank
    }
    
    static let a1 = Square(file: ._A, rank: ._1)
    static let a2 = Square(file: ._A, rank: ._2)
    static let a3 = Square(file: ._A, rank: ._3)
    static let a4 = Square(file: ._A, rank: ._4)
    static let a5 = Square(file: ._A, rank: ._5)
    static let a6 = Square(file: ._A, rank: ._6)
    static let a7 = Square(file: ._A, rank: ._7)
    static let a8 = Square(file: ._A, rank: ._8)
    
    static let b1 = Square(file: ._B, rank: ._1)
    static let b2 = Square(file: ._B, rank: ._2)
    static let b3 = Square(file: ._B, rank: ._3)
    static let b4 = Square(file: ._B, rank: ._4)
    static let b5 = Square(file: ._B, rank: ._5)
    static let b6 = Square(file: ._B, rank: ._6)
    static let b7 = Square(file: ._B, rank: ._7)
    static let b8 = Square(file: ._B, rank: ._8)
    
    static let c1 = Square(file: ._C, rank: ._1)
    static let c2 = Square(file: ._C, rank: ._2)
    static let c3 = Square(file: ._C, rank: ._3)
    static let c4 = Square(file: ._C, rank: ._4)
    static let c5 = Square(file: ._C, rank: ._5)
    static let c6 = Square(file: ._C, rank: ._6)
    static let c7 = Square(file: ._C, rank: ._7)
    static let c8 = Square(file: ._C, rank: ._8)
    
    static let d1 = Square(file: ._D, rank: ._1)
    static let d2 = Square(file: ._D, rank: ._2)
    static let d3 = Square(file: ._D, rank: ._3)
    static let d4 = Square(file: ._D, rank: ._4)
    static let d5 = Square(file: ._D, rank: ._5)
    static let d6 = Square(file: ._D, rank: ._6)
    static let d7 = Square(file: ._D, rank: ._7)
    static let d8 = Square(file: ._D, rank: ._8)
    
    static let e1 = Square(file: ._E, rank: ._1)
    static let e2 = Square(file: ._E, rank: ._2)
    static let e3 = Square(file: ._E, rank: ._3)
    static let e4 = Square(file: ._E, rank: ._4)
    static let e5 = Square(file: ._E, rank: ._5)
    static let e6 = Square(file: ._E, rank: ._6)
    static let e7 = Square(file: ._E, rank: ._7)
    static let e8 = Square(file: ._E, rank: ._8)
    
    static let f1 = Square(file: ._F, rank: ._1)
    static let f2 = Square(file: ._F, rank: ._2)
    static let f3 = Square(file: ._F, rank: ._3)
    static let f4 = Square(file: ._F, rank: ._4)
    static let f5 = Square(file: ._F, rank: ._5)
    static let f6 = Square(file: ._F, rank: ._6)
    static let f7 = Square(file: ._F, rank: ._7)
    static let f8 = Square(file: ._F, rank: ._8)
    
    static let g1 = Square(file: ._G, rank: ._1)
    static let g2 = Square(file: ._G, rank: ._2)
    static let g3 = Square(file: ._G, rank: ._3)
    static let g4 = Square(file: ._G, rank: ._4)
    static let g5 = Square(file: ._G, rank: ._5)
    static let g6 = Square(file: ._G, rank: ._6)
    static let g7 = Square(file: ._G, rank: ._7)
    static let g8 = Square(file: ._G, rank: ._8)
    
    static let h1 = Square(file: ._H, rank: ._1)
    static let h2 = Square(file: ._H, rank: ._2)
    static let h3 = Square(file: ._H, rank: ._3)
    static let h4 = Square(file: ._H, rank: ._4)
    static let h5 = Square(file: ._H, rank: ._5)
    static let h6 = Square(file: ._H, rank: ._6)
    static let h7 = Square(file: ._H, rank: ._7)
    static let h8 = Square(file: ._H, rank: ._8)
}
