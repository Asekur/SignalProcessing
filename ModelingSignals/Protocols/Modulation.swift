//
//  GroupModulation.swift
//  ModelingSignals
//
//  Created by Chegelik on 01.11.2021.
//

import Foundation

protocol Modulation {
    func getValue() -> Float
    func incrementPhase()
}
