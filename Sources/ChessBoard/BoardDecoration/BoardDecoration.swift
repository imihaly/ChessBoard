//
// BoardDecoration.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation

public class BoardDecoration: Identifiable {
    public var id = UUID()
    
    public init(id: UUID = UUID()) {
        self.id = id
    }
}
