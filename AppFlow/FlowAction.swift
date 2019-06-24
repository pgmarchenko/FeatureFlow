//
//  FlowAction.swift
//  AppFlow
//
//  Created by Pavel Marchanka on 6/24/19.
//  Copyright © 2019 Pavel Marchanka. All rights reserved.
//

import Foundation

public protocol FlowAction {}

public protocol FlowInputAction: FlowAction {}

public protocol FlowOutputAction: FlowAction {
    func isEqualTo(_ other: FlowOutputAction) -> Bool
    func asEquatable() -> AnyEquatableAction
}

extension FlowOutputAction where Self: Equatable {
    public func isEqualTo(_ other: FlowOutputAction) -> Bool {
        guard let otherX = other as? Self else { return false }
        return self == otherX
    }
    
    public func asEquatable() -> AnyEquatableAction {
        return AnyEquatableAction(self)
    }
}

public struct AnyEquatableAction: FlowOutputAction, Equatable {
    init(_ value: FlowOutputAction) { self.value = value }
    
    public static func ==(lhs: AnyEquatableAction, rhs: AnyEquatableAction) -> Bool {
        return lhs.value.isEqualTo(rhs.value)
    }
    
    private let value: FlowOutputAction
}

