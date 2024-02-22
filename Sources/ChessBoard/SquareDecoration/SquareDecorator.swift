//
// SquareDecorator.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import SwiftUI

public protocol SquareDecorator {
    func view(for decoration: SquareDecoration) -> AnyView?
}
