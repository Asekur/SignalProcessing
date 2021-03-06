//
//  ViewController.swift
//  ModelingSignals
//
//  Created by Chegelik on 19.09.2021.
//

import Cocoa
import Charts

class ViewController: NSViewController {
    
    @IBOutlet weak var signalChart: LineChartView!
    @IBOutlet weak var modelingTypeSegmentControl: NSSegmentedControl!
    
    //основной сигнал
    @IBOutlet weak var signalTypePopUpButton: NSPopUpButton!
    @IBOutlet weak var phaseTextField: NSTextField!
    @IBOutlet weak var frequencyTextField: NSTextField!
    @IBOutlet weak var amplitudeTextField: NSTextField!
    @IBOutlet weak var dutyTextField: NSTextField!
    
    //модулирующий сигнал
    @IBOutlet weak var signalTypeModulePopUpButton: NSPopUpButton!
    @IBOutlet weak var phaseModuleTextField: NSTextField!
    @IBOutlet weak var frequencyModuleTextField: NSTextField!
    @IBOutlet weak var amplitudeModuleTextField: NSTextField!
    @IBOutlet weak var dutyModuleTextField: NSTextField!
    
    private let chartColor = NSColor(calibratedRed: 0.3, green: 0.5, blue: 0.5, alpha: 1).cgColor
    private var signalPlayer: SignalPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func detectSignalWithType(typeNumber: Int, phase: Float, frequency: Float, amplitude: Float, duty: Float) -> Signal {
        switch typeNumber {
        case 0:
            return Signal(signalType: SignalFormulas.sinus, currentPhase: phase, frequency: frequency, amplitude: amplitude)
        case 1:
            SignalFormulas.duty = duty * SignalFormulas.doublePi / 100.0
            return Signal(signalType: SignalFormulas.impulse, currentPhase: phase, frequency: frequency, amplitude: amplitude)
        case 2:
            return Signal(signalType: SignalFormulas.triangle, currentPhase: phase, frequency: frequency, amplitude: amplitude)
        case 3:
            return Signal(signalType: SignalFormulas.sawtooth, currentPhase: phase, frequency: frequency, amplitude: amplitude)
        case 4:
            return Signal(signalType: SignalFormulas.noise, currentPhase: phase, frequency: frequency, amplitude: amplitude)
        default:
            fatalError()
        }
    }
    
    func defaultSignalCreate() -> Modulation {
        let phase = phaseTextField.floatValue / 180 * Float.pi
        let frequency = frequencyTextField.floatValue / 100
        
        return detectSignalWithType(typeNumber: signalTypePopUpButton.indexOfSelectedItem, phase: phase, frequency: frequency, amplitude: amplitudeTextField.floatValue, duty: dutyTextField.floatValue)
    }
    
    func polyharmonicSignalCreate() -> Modulation {
        let phase = phaseTextField.floatValue / 180 * Float.pi
        let phaseModule = phaseModuleTextField.floatValue / 180 * Float.pi
        
        let frequency = frequencyTextField.floatValue / 100
        let frequencyModule = frequencyModuleTextField.floatValue / 100
        
        let fistSignal = detectSignalWithType(typeNumber: signalTypePopUpButton.indexOfSelectedItem, phase: phase, frequency: frequency, amplitude: amplitudeTextField.floatValue, duty: dutyTextField.floatValue)
        let secondSignal = detectSignalWithType(typeNumber: signalTypeModulePopUpButton.indexOfSelectedItem, phase: phaseModule, frequency: frequencyModule, amplitude: amplitudeModuleTextField.floatValue, duty: dutyModuleTextField.floatValue)
        return GroupPolyharmonic(signals: [fistSignal, secondSignal])
    }
    
    func amplitudeSignalCreate() -> Modulation {
        let phase = phaseTextField.floatValue / 180 * Float.pi
        let phaseModule = phaseModuleTextField.floatValue / 180 * Float.pi
        
        let frequency = frequencyTextField.floatValue / 100
        let frequencyModule = frequencyModuleTextField.floatValue / 100
        
        let carrierSignal = detectSignalWithType(typeNumber: signalTypePopUpButton.indexOfSelectedItem, phase: phase, frequency: frequency, amplitude: amplitudeTextField.floatValue, duty: dutyTextField.floatValue)
        let modulationSignal = detectSignalWithType(typeNumber: signalTypeModulePopUpButton.indexOfSelectedItem, phase: phaseModule, frequency: frequencyModule, amplitude: amplitudeModuleTextField.floatValue, duty: dutyModuleTextField.floatValue)
        return GroupAmplitude(carrierSignal: carrierSignal, modulationSignal: modulationSignal)
    }
    
    func frequencySignalCreate() -> Modulation {
        let phase = phaseTextField.floatValue / 180 * Float.pi
        let phaseModule = phaseModuleTextField.floatValue / 180 * Float.pi
        
        let frequency = frequencyTextField.floatValue / 100
        let frequencyModule = frequencyModuleTextField.floatValue / 100
        
        let carrierSignal = detectSignalWithType(typeNumber: signalTypePopUpButton.indexOfSelectedItem, phase: phase, frequency: frequency, amplitude: amplitudeTextField.floatValue, duty: dutyTextField.floatValue)
        let modulationSignal = detectSignalWithType(typeNumber: signalTypeModulePopUpButton.indexOfSelectedItem, phase: phaseModule, frequency: frequencyModule, amplitude: amplitudeModuleTextField.floatValue, duty: dutyModuleTextField.floatValue)
        return GroupFrequency(carrierSignal: carrierSignal, modulationSignal: modulationSignal, currentPhase:  phase)
    }
    
    @IBAction func generateClick(_ sender: Any) {
        self.signalChart.data?.clearValues()
        self.setData()
        let modelingType = modelingTypeSegmentControl.indexOfSelectedItem
        let signal: Modulation!
        //отображение сигнала на графике
        switch modelingType {
        case 0:
            signal = defaultSignalCreate()
        case 1:
            signal = polyharmonicSignalCreate()
        case 2:
            signal = amplitudeSignalCreate()
        case 3:
            signal = frequencySignalCreate()
        default:
            fatalError()
        }
        
        //график
        for i in 0..<SignalFormulas.frameCount {
            //let value = Double(signal.getValue())
            self.appendData(data: ChartDataEntry(x: Double(i), y: Double(signal.getValue())))
            signal.incrementPhase()
        }
    
        //воспроизведение звука
        self.signalPlayer?.stopEngine()
        self.signalPlayer = SignalPlayer(modulation: signal)
        self.signalPlayer?.reproduceSignal()
    }
    
    private func setupUI() {
        self.setupChart()
        self.setData()
    }
    
    //настройка графика
    private func setupChart() {
        self.signalChart.rightAxis.enabled = false
        self.signalChart.dragEnabled = true
        self.signalChart.doubleTapToZoomEnabled = false
        
        let yAxis =  self.signalChart.leftAxis
        yAxis.drawGridLinesEnabled = false
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.valueFormatter = DefaultAxisValueFormatter(decimals: 100)
        
        let xAxis =  self.signalChart.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = false
        xAxis.labelPosition = .bottom
        
        self.signalChart.animate(xAxisDuration: 0.5, easingOption: .linear)
    }
    
    //установка данных на график
    private func setData() {
        let set = getDataSet(color: chartColor, label: "Signal", alpha: 0.3)
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        self.signalChart.data = data
    }
    
    //настройка линий
    private func getDataSet(color: CGColor, label: String, alpha: Double) -> LineChartDataSet {
        let set = LineChartDataSet(label: label)
        set.mode = .linear
        set.drawCirclesEnabled = false
        set.drawFilledEnabled = true
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.fill = Fill(color: (NSUIColor(cgColor: chartColor) ?? .blue))
        set.fillAlpha = CGFloat(alpha)
        set.highlightColor = .clear
        set.lineWidth = 2
        set.setColor(NSUIColor(cgColor: chartColor) ?? .blue)
        return set
    }
}

// MARK: - SignalDelegate
extension ViewController: SignalDelegate {
    func appendData(data: ChartDataEntry) {
        DispatchQueue.main.async {
            self.signalChart.data?.addEntry(data, dataSetIndex: 0)
            self.signalChart.notifyDataSetChanged()
        }
    }
}

