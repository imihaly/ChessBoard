//
// BoardDecorator.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation
import SwiftUI

public protocol BoardDecorator {
    func view(for decoration: BoardDecoration, geometry: BoardGeometry) -> AnyView?
}


