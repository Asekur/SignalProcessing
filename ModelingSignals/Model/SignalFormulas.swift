//
//  SignalFormulas.swift
//  ModelingSignals
//
//  Created by Chegelik on 01.11.2021.
//

import Foundation

class SignalFormulas {
    //скважность
    static var duty = Float.pi
    static let doublePi = 2 * Float.pi
    //N
    static let frameCount = 1024
    
    static let sinus = { (phase: Float) -> Float in
        return sin(phase)
    }
    
    static let impulse = { (phase: Float) -> Float in
        return phase <= duty ? 1.0 : -1.0
    }
    
    static let triangle = { (phase: Float) -> Float in
        var value = (2.0 * (phase * (1.0 / doublePi))) - 1.0
        if value < 0.0 {
            value = -value
        }
        return 2.0 * (value - 0.5)
    }
    
    static let sawtooth = { (phase: Float) -> Float in
        return 1.0 - 2.0 * (phase * (1.0 / doublePi))
    }
    
    static let noise = { (phase: Float) -> Float in
        return Float.random(in: -1.0...1.0)
    }
}
