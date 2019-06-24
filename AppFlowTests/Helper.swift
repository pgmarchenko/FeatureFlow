//
//  Helper.swift
//  AppFlowTests
//
//  Created by Pavel Marchanka on 6/24/19.
//  Copyright © 2019 Pavel Marchanka. All rights reserved.
//

import Foundation
import RxSwift

import AppFlow
import Nimble

public func beEqual(_ expectedValue: [FlowOutputAction]) -> Predicate<[FlowOutputAction]> {
    return Predicate.define("equal <\(stringify(expectedValue))>") { actualExpression, msg in
        guard let actualValue = try actualExpression.evaluate() else {
            return PredicateResult(
                status: .fail,
                message: msg.appendedBeNilHint()
            )
        }
        
        let matches = areEqual(lhs: expectedValue, other: actualValue)
        return PredicateResult(bool: matches, message: msg)
    }
}

func areEqual(lhs: [FlowOutputAction], other: [FlowOutputAction]) -> Bool {
    guard lhs.count == other.count else { return false }
    guard lhs.count > 0 else { return true }
    
    return !zip(lhs, other).contains { (arg) -> Bool in
        let (lhs, rhs) = arg
        let notEqual = lhs.asEquatable() != rhs.asEquatable()
        if notEqual {
            debugPrint("not equal items: \(lhs) \(rhs)")
        }
        
        return notEqual
    }
}

func == (lhs: Expectation<[FlowOutputAction]>, other: [FlowOutputAction]) {
    lhs.to(beEqual(other))
}
