//
//  Array+FeatureFlowCommand.swift
//  FeatureFlow
//
//  Created by Pavel Marchanka on 6/24/19.
//  Copyright © 2019 Pavel Marchanka. All rights reserved.
//

import Foundation

public extension Array where Element == FeatureFlowCommand {
    func isEqualTo(_ other: [FeatureFlowCommand]) -> Bool {
        guard self.count == other.count else { return false }
        guard self.count > 0 else { return true }
        
        return !zip(self, other).contains { (arg) -> Bool in
            let (lhs, rhs) = arg
            let notEqual = lhs.asEquatable() != rhs.asEquatable()
            if notEqual {
                debugPrint("not equal items: \(lhs) \(rhs)")
            }
            
            return notEqual
        }
    }
}
