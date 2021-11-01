//
//  SignalPlayer.swift
//  ModelingSignals
//
//  Created by Chegelik on 01.11.2021.
//

import Foundation
import AVFoundation
import Charts

//описание аудио и графиков
class SignalPlayer {
    private let engine = AVAudioEngine()
    private var appendChart = true
    weak var delegate: SignalDelegate?
    
    private func getSourceNode() -> AVAudioSourceNode {
        return AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                var value: Float = 0.0
                //for _ in 0..<self.k {
                //    value += self.modulation.getValue()
                //}
                
                //self.modulation.incrementPhase()
                
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = value
                }
                
                //отображение на графике
                if self.appendChart {
                    self.delegate?.appendData(data: ChartDataEntry(x: Double(frame), y: Double(value)))
                }
            }
            self.appendChart = false
            return noErr
        }
    }
    
    private func setupEngine() {
//        self.mainMixer = engine.mainMixerNode
//        self.output = engine.outputNode
//        self.outputFormat = self.output.inputFormat(forBus: 0)
//        self.sampleRate = Float(self.outputFormat.sampleRate)
//        self.inputFormat = AVAudioFormat(commonFormat: outputFormat.commonFormat,
//                                         sampleRate: outputFormat.sampleRate,
//                                         channels: 1,
//                                         interleaved: outputFormat.isInterleaved)
//        self.srcNode = getSourceNode()
//        engine.attach(self.srcNode)
//        engine.connect(self.srcNode, to: mainMixer, format: inputFormat)
//        engine.connect(mainMixer, to: output, format: outputFormat)
    }
}
