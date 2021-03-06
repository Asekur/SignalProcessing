//
//  Signal.swift
//  ModelingSignals
//
//  Created by Chegelik on 01.11.2021.
//

import Foundation

//описание сигнала
class Signal: Modulation {
    // MARK: - Properties
    private var type: (Float) -> Float
    private var currentPhase: Float
    private var frequency: Float
    private var amplitude: Float
    private var incrementPhaseValue: Float
    
    // MARK: - Init
    init(signalType: @escaping (Float) -> Float, currentPhase: Float, frequency: Float, amplitude: Float) {
        self.type = signalType
        self.currentPhase = currentPhase
        self.frequency = frequency
        self.amplitude = amplitude
        //на сколько изменяется значение
        self.incrementPhaseValue = SignalFormulas.doublePi / Float(SignalFormulas.frameCount) * frequency
    }
    
    // MARK: - Methods
    func getValue(for phase: Float) -> Float {
        return type(phase) * self.amplitude
    }
    
    func getValue() -> Float {
        return type(self.currentPhase) * self.amplitude
    }
    
    func getIncrementPhase() -> Float {
        return self.incrementPhaseValue
    }
    
    func incrementPhase() {
        self.currentPhase += self.incrementPhaseValue
        if self.currentPhase >= SignalFormulas.doublePi {
            self.currentPhase -= SignalFormulas.doublePi
        }
        if self.currentPhase < 0.0 {
            self.currentPhase += SignalFormulas.doublePi
        }
    }
    
    func getValueAM() -> Float {
        return type(self.currentPhase)
    }
}
