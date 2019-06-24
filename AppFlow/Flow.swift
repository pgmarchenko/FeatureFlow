//
//  Flow.swift
//  DPMFlow
//
//  Created by Pavel Marchanka on 5/30/19.
//  Copyright © 2019 Pavel Marchenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// 
///
open class AbstractFlow {
    public let output = PublishSubject<FlowOutputAction>()

    public init(record: Bool = false) {
        input
            .bind(onNext: processInput)
            .disposed(by: disposeBag)

        if record {
            output
                .bind { action in
                    self.outputLog.append(action)
                }
                .disposed(by: disposeBag)
        }
    }

    public func `do`(_ action: FlowInputAction) {
        input.onNext(action)
    }

    @discardableResult
    public func popRecordedOutput() -> [FlowOutputAction] {
        defer { outputLog.removeAll() }

        return outputLog
    }

    public func output(_ action: FlowOutputAction) {
        self.output.onNext(action)
    }

    public func output(_ actions: [FlowOutputAction]) {
        actions.forEach(output)
    }

    public func output(_ actions: FlowOutputAction...) {
        output(actions)
    }

    func processInput(_ input: FlowInputAction) {
        childFlows.forEach { $0.do(input) }
    }

    func processInput(_ handler: @escaping (FlowInputAction) -> Void) -> Disposable {
        return input.bind(onNext: handler)
    }

    func processInput(filter: @escaping (FlowInputAction) -> Bool, _ handler: @escaping (FlowInputAction) -> Void) -> Disposable {
        return input
            .filter(filter)
            .bind(onNext: handler)
    }

    func takeActions<Action: FlowInputAction>(count: Int? = nil, _ handler: @escaping (Action) -> Void) -> Disposable {
        
        let filteredInput = input
            .debug()
            .filter { $0 is Action }
        
        let trimmedInput: Observable<FlowInputAction> = {
            if let count = count {
                return filteredInput
                    .take(count)
            } else {
                return filteredInput
            }
        }()
        
        return trimmedInput
            .map { $0 as! Action }
            .subscribe(onNext: { a in
                handler(a)
            })
    }

    public func handleSingleAction<Action: FlowInputAction>(_ handler: @escaping (Action) -> Void) {
        return takeActions(count: 1, handler)
            .disposed(by: inputDisposeBag)
    }

    public func clearHandlers() {
        inputDisposeBag = DisposeBag()
    }

    func takeFirstFiltered<Action: FlowInputAction>(count: Int = 1, filter: @escaping (Action) -> Bool) -> Observable<Action> {
        return input
            .filter { $0 is Action }
            .map { $0 as! Action }
            .filter(filter)
            .take(count)
    }

//    func exitAction<Action: FlowInputAction>(disposing disposer: CompositeDisposable, _ handler: @escaping (Action) -> Void) {
//        takeActions(handler).disposed(by: disposer)
//    }

    @discardableResult
    func addChildFlow(_ flow: AbstractFlow) -> AbstractFlow {
        childFlows.append(flow)

        flow.output
            .bind(onNext: output)
            .disposed(by: flow.disposeBag)

        return flow
    }

    
    func removeAllChildFlows() {
        childFlows.removeAll()
    }
    
    func removeFlow(_ flow: AbstractFlow) {
        childFlows.removeAll { $0 === flow }
    }

    public let disposeBag = DisposeBag()

    let input = PublishSubject<FlowInputAction>()
    let finished = PublishSubject<FlowInputAction>()

    private var childFlows = [AbstractFlow]()
    private var inputDisposeBag = DisposeBag()
    
    private var outputLog = [FlowOutputAction]()
}

public extension AbstractFlow {
    struct Start: FlowInputAction { public init() {} }
}

