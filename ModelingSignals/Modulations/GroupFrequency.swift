//
//  GroupFrequency.swift
//  ModelingSignals
//
//  Created by Chegelik on 01.11.2021.
//

import Foundation

class GroupFrequency: Modulation {
    // MARK: - Properties
    private var carrierSignal: Signal
    private var modulationSignal: Signal
    private var currentPhase: Float = 0.0
    
    // MARK: - Init
    init(carrierSignal: Signal, modulationSignal: Signal, currentPhase: Float) {
        self.carrierSignal = carrierSignal
        self.modulationSignal = modulationSignal
        self.currentPhase = currentPhase
    }
    
    // MARK: - Methods
    func getValue() -> Float  {
        return self.carrierSignal.getValue(for: self.currentPhase)
    }
    
    func incrementPhase() {
        self.modulationSignal.incrementPhase()
        self.currentPhase += self.carrierSignal.getIncrementPhase() * (1 + self.modulationSignal.getValue())

        if self.currentPhase >= SignalFormulas.doublePi {
            self.currentPhase -= SignalFormulas.doublePi
        }
        if self.currentPhase < 0.0 {
            self.currentPhase += SignalFormulas.doublePi
        }
    }
}
