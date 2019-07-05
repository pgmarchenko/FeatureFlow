//
//  AppFlowTests.swift
//  AppFlowTests
//
//  Created by Pavel Marchanka on 6/24/19.
//  Copyright © 2019 Pavel Marchanka. All rights reserved.
//

import Quick
import Nimble

import FeatureFlow
import RxSwift

class ExampleFlowTests: QuickSpec {
    override func spec() {
        describe("Single input") {
            let flow = AppFlow(record: true)

            beforeEach {
                flow.reset()
            }

            expectFlow(flow, [
                (
                    onEvents: [AppLaunched()],
                    commands: [PadsScreenShow()]
                ),
                branches(
                    [
                        (
                            onEvents: [MenuSelected()],
                            commands: [MenuScreenShow()]
                        ),
                        menuExpectations()
                    ],
                    [
                        (
                            onEvents: [SequencerSelected()],
                            commands: [SequencerScreenShow()]
                        ),
                        sequencerExpectations()
                    ]
                )
                ]
            )
        }
    }
}

func menuExpectations() -> [Any] {
    return [
        [
            (
                onEvents: [PadsSelected()],
                commands: [PadsScreenShow()]
            )
        ]
    ]
}

func sequencerExpectations() -> [Any] {
    return [
        [
            (
                onEvents: [PadsSelected()],
                commands: [PadsScreenShow()]
            )
        ]
    ]
}


private func branches(_ branches: Any...) -> [Any] {
    return branches
}
