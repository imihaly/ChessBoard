//
// DragCapturingView.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//

import Foundation
import SwiftUI

public struct Modifiers: OptionSet {
    public let rawValue: Int
    
    public static let shift = Modifiers(rawValue: 1 << 0)
    public static let control = Modifiers(rawValue: 1 << 1)
    public static let option = Modifiers(rawValue: 1 << 2)
    public static let command = Modifiers(rawValue: 1 << 3)
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}


#if os(macOS)

import AppKit

class NSEventHandlerHostingView<Content>: NSHostingView<Content> where Content: View {
    
    var onRightMouseDown: (CGPoint, Modifiers) -> Void
    var onRightMouseUp: (CGPoint, Modifiers) -> Void
    var onRightMouseClick: (CGPoint, Modifiers) -> Void
    var onRightMouseDragging: (CGPoint, CGPoint, Modifiers) -> Void
    var onRightMouseDragged: (CGPoint, CGPoint, Modifiers) -> Void
    
    enum RightMouseState {
        case none
        case down(start: CGPoint)
        case dragging(start: CGPoint)
    }
    
    var rightMouseState: RightMouseState = .none

    required init(rootView: Content,
                  onRightMouseDown: @escaping (CGPoint, Modifiers) -> Void = {_, _ in },
                  onRightMouseUp: @escaping (CGPoint, Modifiers) -> Void = {_, _ in },
                  onRightMouseClick: @escaping (CGPoint, Modifiers) -> Void = {_, _ in },
                  onRightMouseDragging: @escaping (CGPoint, CGPoint, Modifiers) -> Void = {_, _, _ in },
                  onRightMouseDragged: @escaping (CGPoint, CGPoint, Modifiers) -> Void = {_, _, _ in }
    ) {
        self.onRightMouseDown = onRightMouseDown
        self.onRightMouseUp = onRightMouseUp
        self.onRightMouseClick = onRightMouseClick
        self.onRightMouseDragging = onRightMouseDragging
        self.onRightMouseDragged = onRightMouseDragged
        
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(rootView: Content) {
        fatalError("init(coder:) has not been implemented")
    }


    override func rightMouseDown(with event: NSEvent) {
        let location = self.convert(event.locationInWindow, from: nil)
        onRightMouseDown(location, modifiers(from: event))
        rightMouseState = .down(start: location)
    }
    
    override func rightMouseUp(with event: NSEvent) {
        let location = self.convert(event.locationInWindow, from: nil)
        let modifiers = modifiers(from: event)
        onRightMouseUp(location, modifiers)
        
        switch rightMouseState {
        case .none:
            break
        case .down(start: _):
            onRightMouseClick(location, modifiers)
            break
        case .dragging(start: let start):
            onRightMouseDragged(start, location, modifiers)
        }
        rightMouseState = .none
    }
    
    override func rightMouseDragged(with event: NSEvent) {
        let location = self.convert(event.locationInWindow, from: nil)
        let modifiers = modifiers(from: event)
        
        switch rightMouseState {
        case .none:
            break
        case .down(start: let start):
            let distance = distance(point1: start, point2: location)
            if distance < 10.0 {
                break
            } else {
                // switch to dragging
                rightMouseState = .dragging(start: start)
                onRightMouseDragging(start, location, modifiers)
            }
            break
        case .dragging(start: let start):
            onRightMouseDragging(start, location, modifiers)
        }
    }
    
    private
    func modifiers(from event: NSEvent) -> Modifiers {
        var modifiers = Modifiers(rawValue: 0)
        if event.modifierFlags.contains(.shift) {
            modifiers.insert(.shift)
        }
        if event.modifierFlags.contains(.control) {
            modifiers.insert(.control)
        }
        if event.modifierFlags.contains(.option) {
            modifiers.insert(.option)
        }
        if event.modifierFlags.contains(.command) {
            modifiers.insert(.command)
        }
        return modifiers
    }
    
    private
    func distance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        return max(abs(point1.x - point2.x), abs(point1.y - point2.y))
    }
}

struct NSEventHandler<Content>: NSViewRepresentable where Content: View {
    
    var contentView: Content
    var onRightMouseDown: (CGPoint, Modifiers) -> Void = {_, _ in }
    var onRightMouseUp: (CGPoint, Modifiers) -> Void = {_, _ in }
    var onRightMouseClick: (CGPoint, Modifiers) -> Void = {_, _ in }
    var onRightMouseDragging: (CGPoint, CGPoint, Modifiers) -> Void = {_, _, _ in }
    var onRightMouseDragged: (CGPoint, CGPoint, Modifiers) -> Void = {_, _, _ in }

    func makeNSView(context: Context) -> NSEventHandlerHostingView<Content> {
        let hostingView = NSEventHandlerHostingView(rootView: contentView,
                                                    onRightMouseDown: onRightMouseDown,
                                                    onRightMouseUp: onRightMouseUp,
                                                    onRightMouseClick: onRightMouseClick,
                                                    onRightMouseDragging: onRightMouseDragging,
                                                    onRightMouseDragged: onRightMouseDragged
        )
        return hostingView
    }
    
    func updateNSView(_ nsView: NSEventHandlerHostingView<Content>, context: Context) {
        nsView.onRightMouseDown = onRightMouseDown
        nsView.onRightMouseUp = onRightMouseUp
        nsView.onRightMouseClick = onRightMouseClick
        nsView.onRightMouseDragging = onRightMouseDragging
        nsView.onRightMouseDragged = onRightMouseDragged
    }
}

struct NSEventHandlerModifier: ViewModifier {
    var onRightMouseDown: (CGPoint, Modifiers) -> Void = {_, _ in }
    var onRightMouseUp: (CGPoint, Modifiers) -> Void = {_, _ in }
    var onRightMouseClick: (CGPoint, Modifiers) -> Void = {_, _ in }
    var onRightMouseDragging: (CGPoint, CGPoint, Modifiers) -> Void = {_, _, _ in }
    var onRightMouseDragged: (CGPoint, CGPoint, Modifiers) -> Void = {_, _, _ in }
    
    func body(content: Content) -> some View {
        NSEventHandler(contentView: content,
                       onRightMouseDown: onRightMouseDown,
                       onRightMouseUp: onRightMouseUp,
                       onRightMouseClick: onRightMouseClick,
                       onRightMouseDragging: onRightMouseDragging,
                       onRightMouseDragged: onRightMouseDragged
        )
    }
}

#else

struct NSEventHandlerModifier: ViewModifier {
    var onRightMouseDown: (CGPoint, Modifiers) -> Void = {_, _ in }
    var onRightMouseUp: (CGPoint, Modifiers) -> Void = {_, _ in }
    var onRightMouseClick: (CGPoint, Modifiers) -> Void = {_, _ in }
    var onRightMouseDragging: (CGPoint, CGPoint, Modifiers) -> Void = {_, _, _ in }
    var onRightMouseDragged: (CGPoint, CGPoint, Modifiers) -> Void = {_, _, _ in }

    func body(content: Content) -> some View {
        content
    }
}
#endif

extension View {
    func nsEvents(
        onRightMouseDown: @escaping (CGPoint, Modifiers) -> Void = {_, _ in },
        onRightMouseUp: @escaping (CGPoint, Modifiers) -> Void = {_, _ in },
        onRightMouseClick: @escaping (CGPoint, Modifiers) -> Void = {_, _ in },
        onRightMouseDragging: @escaping (CGPoint, CGPoint, Modifiers) -> Void = {_, _, _ in },
        onRightMouseDragged: @escaping (CGPoint, CGPoint, Modifiers) -> Void = {_, _, _ in }
    ) -> some View {
        modifier(NSEventHandlerModifier(
            onRightMouseDown: onRightMouseDown,
            onRightMouseUp: onRightMouseUp,
            onRightMouseClick: onRightMouseClick,
            onRightMouseDragging: onRightMouseDragging,
            onRightMouseDragged: onRightMouseDragged
        ))
    }
}
