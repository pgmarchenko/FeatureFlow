//
//  ExampleFlow.swift
//  AppFlowTests
//
//  Created by Pavel Marchanka on 6/24/19.
//  Copyright © 2019 Pavel Marchanka. All rights reserved.
//

import Foundation
import FeatureFlow


struct AppLaunched: FeatureFlowEvent {}

struct SequencerSelected: FeatureFlowEvent {}
struct PadsSelected: FeatureFlowEvent {}
struct StartRecordSelected: FeatureFlowEvent {}

struct MenuSelected: FeatureFlowEvent {}
struct MoreSelected: FeatureFlowEvent {}


class AppFlow: FeatureFlow {
    override init(record: Bool = false) {
        super.init(record: record)
        debugPrint("__init__ app flow")
        
        reset()
    }
    
    override func reset() {
        super.reset()
        
        waitSingleEvent(handleAppLaunched)
    }
    
    deinit {
        debugPrint("deinit")
    }
}

extension AppFlow {
    fileprivate func handleAppLaunched(_ event: AppLaunched) {
        output(PadsScreenShow())
        
        waitSingleEvent(handleSequencerSelected)
        waitSingleEvent(handleMenuSelected)
    }
    
    fileprivate func handleSequencerSelected(_ event: SequencerSelected) {
        output(SequencerScreenShow())
        
        clearHandlers()
        
        waitSingleEvent(handlePadsSelected)
    }
    
    fileprivate func handleMenuSelected(_ event: MenuSelected) {
        output(MenuScreenShow())
        
        clearHandlers()
        
        waitSingleEvent(handlePadsSelected)
    }
    
    fileprivate func handlePadsSelected(_ event: PadsSelected) {
        output(PadsScreenShow())
        
        clearHandlers()
        
        waitSingleEvent(handleSequencerSelected)
        waitSingleEvent(handleMenuSelected)
    }
}


struct PadsScreenShow: FeatureFlowCommand, Equatable {}
struct SequencerScreenShow: FeatureFlowCommand, Equatable {}
struct MenuScreenShow: FeatureFlowCommand, Equatable {}
struct MoreScreenShow: FeatureFlowCommand, Equatable {}
