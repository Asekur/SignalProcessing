//
//  SignalModulation.swift
//  ModelingSignals
//
//  Created by Chegelik on 01.11.2021.
//

import Foundation

protocol SignalModulation {
    //func getFrequency() -> Float
    func getValue(for phase: Float) -> Float
    //func getValue() -> Float
    //func getValueAM() -> Float
    //func getIncrementPhase() -> Float
    //func incrementPhase()
}
