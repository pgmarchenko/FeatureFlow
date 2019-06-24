//
//  ExampleFlow.swift
//  AppFlowTests
//
//  Created by Pavel Marchanka on 6/24/19.
//  Copyright © 2019 Pavel Marchanka. All rights reserved.
//

import Foundation
import AppFlow


class ExampleFlow: AbstractFlow {
    override init(record: Bool = false) {
        super.init(record: record)
        
        handleSingleAction(handleStart)
    }
}

extension ExampleFlow {
    private func handleStart(_ it: Start) {
        output(StartOutput())
    }
}

struct StartOutput: FlowOutputAction, Equatable { }
