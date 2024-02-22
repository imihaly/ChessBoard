//
// DefaultSquareDecorator.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation
import SwiftUI


/// A SquareDecorator supporting square selection and highlight.
public class DefaultSquareDecorator: SquareDecorator {
    public func view(for decoration: SquareDecoration) -> AnyView? {
        switch decoration {
        case is SelectionSquareDecoration:
            return AnyView(
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(Color.red, lineWidth: 4.0)
                    .padding(4.0)
                    .allowsHitTesting(false)
            )
            
        case is HighlightSquareDecoration:
            let highlightDecoration = decoration as! HighlightSquareDecoration
            return AnyView(
                highlightDecoration.type.color
                    .allowsHitTesting(false)
            )
            
        default:
            return nil
        }
    }
}

extension HighlightSquareDecoration.DecorationType {
    var color: Color {
        switch self {
        case .red:
            return Color.red.opacity(0.7)
        case .green:
            return Color.green.opacity(0.7)
        case .orange:
            return Color.orange.opacity(0.7)
        case .blue:
            return Color.blue.opacity(0.7)
        }
    }
}
