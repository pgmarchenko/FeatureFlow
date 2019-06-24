//
//  AppFlowTests.swift
//  AppFlowTests
//
//  Created by Pavel Marchanka on 6/24/19.
//  Copyright © 2019 Pavel Marchanka. All rights reserved.
//

import Quick
import Nimble

import AppFlow
import RxSwift

class ExampleFlowTests: QuickSpec {
    override func spec() {
        describe("Single input") {
            let flow = ExampleFlow(record: true)
            
            flow.do(AbstractFlow.Start())
            
            it("EmptyOutput") {
                expect(flow.popRecordedOutput()) == [
                    StartOutput()
                ]
            }
        }
        
        describe("Two input actions") {
            var flow = ExampleFlow(record: true)
            
            beforeEach {
                flow = ExampleFlow(record: true)
            }
            
            context("First input") {
                beforeEach {
                    flow.do(AbstractFlow.Start())
                    
                    expect(flow.popRecordedOutput()) == [
                        StartOutput()
                    ]
                }
                
                context("Second input") {
                    beforeEach {
                        flow.do(AbstractFlow.Start())
                    }
                    
                    it("No output") {
                        expect(flow.popRecordedOutput()) == []
                    }
                }
            }
            
            
            
        }
    }
}

