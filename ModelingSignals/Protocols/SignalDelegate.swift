//
//  SignalDelegate.swift
//  ModelingSignals
//
//  Created by Chegelik on 01.11.2021.
//

import Charts
import Cocoa

protocol SignalDelegate: AnyObject {
    func appendData(data: ChartDataEntry)
}
