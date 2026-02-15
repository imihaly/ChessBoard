//
// Square.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation

public enum File: Int, Codable, Hashable {
    case _A = 0
    case _B = 1
    case _C = 2
    case _D = 3
    case _E = 4
    case _F = 5
    case _G = 6
    case _H = 7
    
    public var name: String {
        ["a", "b", "c", "d", "e", "f", "g", "h"][self.rawValue]
    }
}

public enum Rank: Int, Codable, Hashable {
    case _1 = 0
    case _2 = 1
    case _3 = 2
    case _4 = 3
    case _5 = 4
    case _6 = 5
    case _7 = 6
    case _8 = 7
    
    public var name: String {
        "\(rawValue + 1)"
    }
}

public struct Square : Equatable, Codable, Hashable {
    
    public var description: String {
        file.name + rank.name
    }
    
    public let file: File
    public let rank: Rank
    
    public init(file: File, rank: Rank) {
        self.file = file
        self.rank = rank
    }
    
    public init?(x: Int, y: Int) {
        guard let file = File(rawValue: x), let rank = Rank(rawValue: y) else {
            return nil
        }
        
        self.file = file
        self.rank = rank
    }
    
    public static let a1 = Square(file: ._A, rank: ._1)
    public static let a2 = Square(file: ._A, rank: ._2)
    public static let a3 = Square(file: ._A, rank: ._3)
    public static let a4 = Square(file: ._A, rank: ._4)
    public static let a5 = Square(file: ._A, rank: ._5)
    public static let a6 = Square(file: ._A, rank: ._6)
    public static let a7 = Square(file: ._A, rank: ._7)
    public static let a8 = Square(file: ._A, rank: ._8)
    
    public static let b1 = Square(file: ._B, rank: ._1)
    public static let b2 = Square(file: ._B, rank: ._2)
    public static let b3 = Square(file: ._B, rank: ._3)
    public static let b4 = Square(file: ._B, rank: ._4)
    public static let b5 = Square(file: ._B, rank: ._5)
    public static let b6 = Square(file: ._B, rank: ._6)
    public static let b7 = Square(file: ._B, rank: ._7)
    public static let b8 = Square(file: ._B, rank: ._8)
    
    public static let c1 = Square(file: ._C, rank: ._1)
    public static let c2 = Square(file: ._C, rank: ._2)
    public static let c3 = Square(file: ._C, rank: ._3)
    public static let c4 = Square(file: ._C, rank: ._4)
    public static let c5 = Square(file: ._C, rank: ._5)
    public static let c6 = Square(file: ._C, rank: ._6)
    public static let c7 = Square(file: ._C, rank: ._7)
    public static let c8 = Square(file: ._C, rank: ._8)
    
    public static let d1 = Square(file: ._D, rank: ._1)
    public static let d2 = Square(file: ._D, rank: ._2)
    public static let d3 = Square(file: ._D, rank: ._3)
    public static let d4 = Square(file: ._D, rank: ._4)
    public static let d5 = Square(file: ._D, rank: ._5)
    public static let d6 = Square(file: ._D, rank: ._6)
    public static let d7 = Square(file: ._D, rank: ._7)
    public static let d8 = Square(file: ._D, rank: ._8)
    
    public static let e1 = Square(file: ._E, rank: ._1)
    public static let e2 = Square(file: ._E, rank: ._2)
    public static let e3 = Square(file: ._E, rank: ._3)
    public static let e4 = Square(file: ._E, rank: ._4)
    public static let e5 = Square(file: ._E, rank: ._5)
    public static let e6 = Square(file: ._E, rank: ._6)
    public static let e7 = Square(file: ._E, rank: ._7)
    public static let e8 = Square(file: ._E, rank: ._8)
    
    public static let f1 = Square(file: ._F, rank: ._1)
    public static let f2 = Square(file: ._F, rank: ._2)
    public static let f3 = Square(file: ._F, rank: ._3)
    public static let f4 = Square(file: ._F, rank: ._4)
    public static let f5 = Square(file: ._F, rank: ._5)
    public static let f6 = Square(file: ._F, rank: ._6)
    public static let f7 = Square(file: ._F, rank: ._7)
    public static let f8 = Square(file: ._F, rank: ._8)
    
    public static let g1 = Square(file: ._G, rank: ._1)
    public static let g2 = Square(file: ._G, rank: ._2)
    public static let g3 = Square(file: ._G, rank: ._3)
    public static let g4 = Square(file: ._G, rank: ._4)
    public static let g5 = Square(file: ._G, rank: ._5)
    public static let g6 = Square(file: ._G, rank: ._6)
    public static let g7 = Square(file: ._G, rank: ._7)
    public static let g8 = Square(file: ._G, rank: ._8)
    
    public static let h1 = Square(file: ._H, rank: ._1)
    public static let h2 = Square(file: ._H, rank: ._2)
    public static let h3 = Square(file: ._H, rank: ._3)
    public static let h4 = Square(file: ._H, rank: ._4)
    public static let h5 = Square(file: ._H, rank: ._5)
    public static let h6 = Square(file: ._H, rank: ._6)
    public static let h7 = Square(file: ._H, rank: ._7)
    public static let h8 = Square(file: ._H, rank: ._8)
}
