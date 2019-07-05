//
//  FeatureFlowEvent.swift
//  FeatureFlow
//
//  Created by Pavel Marchanka on 6/24/19.
//  Copyright © 2019 Pavel Marchanka. All rights reserved.
//

import Foundation

public protocol FeatureFlowEvent {}

public protocol FeatureFlowCommand {
    func isEqualTo(_ other: FeatureFlowCommand) -> Bool
    func asEquatable() -> AnyEquatableAction
}

extension FeatureFlowCommand where Self: Equatable {
    public func isEqualTo(_ other: FeatureFlowCommand) -> Bool {
        guard let otherX = other as? Self else { return false }
        return self == otherX
    }
    
    public func asEquatable() -> AnyEquatableAction {
        return AnyEquatableAction(self)
    }
}

public struct AnyEquatableAction: FeatureFlowCommand, Equatable {
    init(_ value: FeatureFlowCommand) { self.value = value }
    
    public static func ==(lhs: AnyEquatableAction, rhs: AnyEquatableAction) -> Bool {
        return lhs.value.isEqualTo(rhs.value)
    }
    
    private let value: FeatureFlowCommand
}

