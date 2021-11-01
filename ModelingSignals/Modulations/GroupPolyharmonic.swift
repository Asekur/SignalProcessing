//
//  GroupPolyharmonic.swift
//  ModelingSignals
//
//  Created by Chegelik on 01.11.2021.
//

import Foundation

//складывание сигналов
//модуляция полигармонических сигналов

class GroupPolyharmonic: Modulation {
    // MARK: - Properties
    private var signals = [Signal]()

    // MARK: - Init
    init(signals: [Signal]) {
        self.signals = signals
    }

    // MARK: - Methods
    func getValue() -> Float {
        return self.signals
            .map({ $0.getValue() })
            .reduce(0, +)
    }

    func incrementPhase() {
        self.signals
            .forEach { $0.incrementPhase() }
    }
}
