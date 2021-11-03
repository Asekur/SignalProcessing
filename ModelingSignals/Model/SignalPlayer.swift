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
    private var mainMixer: AVAudioMixerNode!
    private var output: AVAudioOutputNode!
    private var outputFormat: AVAudioFormat!
    private var inputFormat: AVAudioFormat!
    private var sampleRate: Float!
    private var srcNode: AVAudioSourceNode!
    
    private let duration: Int = 3 //продолжительность звука
    private var modulation: Modulation
    
    weak var delegate: SignalDelegate?
    
    // MARK: - Init
    init(modulation: Modulation) {
        self.modulation = modulation
        self.setupEngine()
    }
    
    // MARK: - Methods
    private func saveFile() {
        var samplesWritten: AVAudioFrameCount = 0
        var outputFormatSettings = srcNode.outputFormat(forBus: 0).settings
        outputFormatSettings[AVLinearPCMIsNonInterleaved] = false
        
        let outFile = try? AVAudioFile(forWriting: URL(fileURLWithPath: "file.wav"), settings: outputFormatSettings)
        let samplesToWrite = AVAudioFrameCount(duration * Int(sampleRate))
        srcNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(SignalFormulas.frameCount), format: inputFormat) { buffer, _ in
            if samplesWritten + buffer.frameLength > samplesToWrite {
                buffer.frameLength = samplesToWrite - samplesWritten
            }
            
            do {
                try outFile?.write(from: buffer)
            } catch {
                print("Error writing file \(error)")
            }
            
            samplesWritten += buffer.frameLength
            
            if samplesWritten >= samplesToWrite {
                return
            }
        }
    }
    
    private func getSourceNode() -> AVAudioSourceNode {
        return AVAudioSourceNode { [self] _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let value = modulation.getValue()
                modulation.incrementPhase()
                
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = value
                }
            }
            return noErr
        }
    }
    
    private func setupEngine() {
        self.mainMixer = engine.mainMixerNode
        self.output = engine.outputNode
        self.outputFormat = self.output.inputFormat(forBus: 0)
        self.sampleRate = Float(self.outputFormat.sampleRate)
        self.inputFormat = AVAudioFormat(commonFormat: outputFormat.commonFormat, sampleRate: outputFormat.sampleRate, channels: 1, interleaved: outputFormat.isInterleaved)
        //что именно будет воспроизводиться
        self.srcNode = getSourceNode()
        engine.attach(self.srcNode)
        engine.connect(self.srcNode, to: mainMixer, format: inputFormat)
        engine.connect(mainMixer, to: output, format: outputFormat)
    }
    
    func stopEngine() {
        self.engine.stop()
    }
    
    func reproduceSignal() {
        self.saveFile()
        do {
            try engine.start()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(duration)) {
                self.engine.stop()
            }
        } catch {
            print("Could not start engine: \(error)")
        }
    }
    
    
}
