//
// DefaultBoardDecorator.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation
import SwiftUI

/// A board decorator is supporting drawing arrows between cells.
public
class ArrowBoardDecorator: BoardDecorator {
    public func view(for decoration: BoardDecoration, geometry: BoardGeometry) -> AnyView? {
        guard let arrow = decoration as? Arrow else {
            return nil
        }
        
        let startPoint = geometry.cellFrame(square: arrow.start).center
        let endPoint = geometry.cellFrame(square: arrow.end).center
        let cellSize = CGFloat(geometry.cellSize)
        let tailWidth = CGFloat(0.2) * cellSize
        let headWidth = CGFloat(0.45) * cellSize
        let headLength = CGFloat(0.33) * cellSize
        
        let dRank = arrow.end.rank.rawValue - arrow.start.rank.rawValue
        let dFile = arrow.end.file.rawValue - arrow.start.file.rawValue
        let isKnightMove = (abs(dRank) == 2 && abs(dFile) == 1) || (abs(dRank) == 1 && abs(dFile) == 2)
        
        if isKnightMove {
            let path = CGPath.pathForKnightMoveArrow(cellSize: cellSize, from: startPoint, to: endPoint, tailWidth: tailWidth, headWidth: headWidth, headLengt: headLength)
            return  AnyView(ArrowShape(path: path)
                .foregroundColor(arrow.type.color)
                .allowsHitTesting(false)
            )
        } else {
            let path = CGPath.pathForArrow(cellSize: cellSize, from: startPoint, to: endPoint, tailWidth: tailWidth, headWidth: headWidth, headLengt: headLength)
            return  AnyView(
                ArrowShape(path: path)
                    .foregroundColor(arrow.type.color)
                    .allowsHitTesting(false)
            )
        }
    }
    
    struct ArrowShape: Shape {
        var path: CGPath
        func path(in rect: CGRect) -> Path {
            return Path(path)
        }
    }
}

extension CGPath {
    
    /**
     Builds a straight arrow between the two squares.
     */
    static func pathForArrow(cellSize: CGFloat, from startPoint: CGPoint, to endPoint: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLengt: CGFloat) -> CGPath {
        let distance = CGFloat(hypotf(Float(endPoint.x - startPoint.x), Float(endPoint.y - startPoint.y)))
        let cos = (endPoint.x - startPoint.x) / distance
        let sin = (endPoint.y - startPoint.y) / distance
        
        var points: [CGPoint] = []
        let tailShift =  0.3 * cellSize
        let translation = CGPoint(x: startPoint.x + tailShift * cos, y: startPoint.y + tailShift * sin)
        let halfTailWidth = tailWidth / 2
        let halfHeadWidth = headWidth / 2
        let tailLength = distance - tailShift - headLengt
        let arrowLength = tailLength + headLengt

        points.append(CGPoint(x: translation.x + halfTailWidth * sin, y: translation.y - halfTailWidth * cos))
        points.append(CGPoint(x: translation.x + halfTailWidth * sin + tailLength * cos, y: translation.y - halfTailWidth * cos + tailLength * sin))
        points.append(CGPoint(x: translation.x + halfHeadWidth * sin + tailLength * cos, y: translation.y - halfHeadWidth * cos + tailLength * sin))
        points.append(CGPoint(x: translation.x + arrowLength * cos, y: translation.y + arrowLength * sin))
        points.append(CGPoint(x: translation.x - halfHeadWidth * sin + tailLength * cos, y: translation.y + halfHeadWidth * cos + tailLength * sin))
        points.append(CGPoint(x: translation.x - halfTailWidth * sin + tailLength * cos, y: translation.y + halfTailWidth * cos + tailLength * sin))
        points.append(CGPoint(x: translation.x - halfTailWidth * sin, y: translation.y + halfTailWidth * cos))

        let path = CGMutablePath()
        path.move(to: points[0])

        for i in 1..<points.count {
            path.addLine(to: points[i])
        }

        path.closeSubpath()
        
        return path
    }
    
    /**
     Build a knight-move arrow between the two squares.
     */
    static func pathForKnightMoveArrow(cellSize: CGFloat, from startPoint: CGPoint, to endPoint: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLengt: CGFloat) -> CGPath {
        
        let halfTailWidth = tailWidth / 2
        let halfHeadWidth = headWidth / 2
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let sx = dx < 0 ? -1.0 : 1.0
        let sy = dy < 0 ? -1.0 : 1.0
        
        var points: [CGPoint] = []
        
        let horizontalFirst = abs(dx) > abs(dy)
        if horizontalFirst {
            let turnPoint = CGPoint(x: endPoint.x, y: startPoint.y)
            points.append(CGPoint(x: startPoint.x + sx * 0.3 * cellSize, y: startPoint.y - sy * halfTailWidth))
            points.append(CGPoint(x: turnPoint.x + sx * halfTailWidth, y:  turnPoint.y - sy * halfTailWidth))
            points.append(CGPoint(x: turnPoint.x + sx * halfTailWidth, y:  endPoint.y - sy * headLengt))
            points.append(CGPoint(x: turnPoint.x + sx * halfHeadWidth, y:  endPoint.y - sy * headLengt))
            
            points.append(CGPoint(x: endPoint.x, y: endPoint.y))
            
            points.append(CGPoint(x: turnPoint.x - sx * halfHeadWidth, y:  endPoint.y - sy * headLengt))
            points.append(CGPoint(x: turnPoint.x - sx * halfTailWidth, y:  endPoint.y - sy * headLengt))
            points.append(CGPoint(x: turnPoint.x - sx * halfTailWidth, y:  turnPoint.y + sy * halfTailWidth))
            points.append(CGPoint(x: startPoint.x + sx * 0.3 * cellSize, y: startPoint.y + sy * halfTailWidth))
        } else {
            let turnPoint = CGPoint(x: startPoint.x, y: endPoint.y)
            points.append(CGPoint(x: startPoint.x - sx * halfTailWidth, y: startPoint.y + sy * 0.3 * cellSize))
            points.append(CGPoint(x: turnPoint.x - sx * halfTailWidth, y: turnPoint.y + sy * halfTailWidth))
            points.append(CGPoint(x: endPoint.x - sx * headLengt, y: endPoint.y + sy * halfTailWidth))
            points.append(CGPoint(x: endPoint.x - sx * headLengt, y: endPoint.y + sy * halfHeadWidth))
            
            points.append(CGPoint(x: endPoint.x, y: endPoint.y))
            
            points.append(CGPoint(x: endPoint.x - sx * headLengt, y: endPoint.y - sy * halfHeadWidth))
            points.append(CGPoint(x: endPoint.x - sx * headLengt, y: endPoint.y - sy * halfTailWidth))
            points.append(CGPoint(x: turnPoint.x + sx * halfTailWidth, y: turnPoint.y - sy * halfTailWidth))
            points.append(CGPoint(x: startPoint.x + sx * halfTailWidth, y: startPoint.y + sy * 0.3 * cellSize))
        }
        
        let path = CGMutablePath()
        path.move(to: points[0])
        
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
        
        path.closeSubpath()
        
        return path
    }
}

extension Arrow.DecorationType {
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


