//
//  Helper.swift
//  FeatureFlowTests
//
//  Created by Pavel Marchanka on 6/24/19.
//  Copyright © 2019 Pavel Marchanka. All rights reserved.
//

import Foundation
import RxSwift

import Quick
import Nimble

import FeatureFlow

public func beEqual(_ expectedValue: [FeatureFlowCommand]) -> Predicate<[FeatureFlowCommand]> {
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

func areEqual(lhs: [FeatureFlowCommand], other: [FeatureFlowCommand]) -> Bool {
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

func == (lhs: Expectation<[FeatureFlowCommand]>, other: [FeatureFlowCommand]) {
    lhs.to(beEqual(other))
}


typealias ExpectationTuple = ([FeatureFlowEvent], [FeatureFlowCommand])

func expectFlow(_ flow: FeatureFlow, _ expectations: Any, useIt: Bool = true) {
    if let expectations = expectations as? [Any] {
        guard let e = expectations.first else { return }
        
        switch e {
        case (let events, let commands) as ExpectationTuple:
            context("\(events)") {
                beforeEach {
                    flow.popRecordedCommands()
                    
                    events.forEach(flow.dispatch)
                }
                
                it("\(commands)") {
                    expect(flow.popRecordedCommands()) == commands
                }
                
                expectFlow(flow, Array(expectations.dropFirst()))
            }
        case let expectations as [[Any]]:
            expectations.forEach {
                debugPrint("Branch")
                expectFlow(flow, $0)
            }
        default:
            debugPrint("!!!Unknown expectation!!! \(e)")
        }
    }
    
}
