//
//  GroupAmplitude.swift
//  ModelingSignals
//
//  Created by Chegelik on 01.11.2021.
//

import Foundation

class GroupAmplitude {
    // MARK: - Properties
    private var carrierSignal: Signal
    private var modulationSignal: Signal
    
    // MARK: - Init
    init(carrierSignal: Signal, modulationSignal: Signal) {
        self.carrierSignal = carrierSignal
        self.modulationSignal = modulationSignal
    }
    
    // MARK: - Methods
    func getValue() -> Float {
        return self.carrierSignal.getValueAM() * self.modulationSignal.getValue()
    }
    
    func incrementPhase() {
        self.carrierSignal.incrementPhase()
        self.modulationSignal.incrementPhase()
    }
}
