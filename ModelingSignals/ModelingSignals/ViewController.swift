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
    @IBOutlet weak var phaseTextField: NSTextField!
    @IBOutlet weak var frequencyTextField: NSTextField!
    @IBOutlet weak var amplitudeTextField: NSTextField!
    @IBOutlet weak var dutyTextField: NSTextField!
    @IBOutlet weak var signalTypePopUpButton: NSPopUpButton!
    
    private let chartColor = NSColor(calibratedRed: 0.3, green: 0.5, blue: 0.5, alpha: 1).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func generateClick(_ sender: Any) {
        let typeSignal = signalTypePopUpButton.indexOfSelectedItem
        var signal: Signal!
        
        switch typeSignal {
        case 0:
            signal = Signal(signalType: SignalFormulas.sinus, currentPhase: phaseTextField.floatValue, frequency: frequencyTextField.floatValue, amplitude: amplitudeTextField.floatValue)
        case 1:
            signal = Signal(signalType: SignalFormulas.impulse, currentPhase: phaseTextField.floatValue, frequency: frequencyTextField.floatValue, amplitude: amplitudeTextField.floatValue)
        case 2:
            signal = Signal(signalType: SignalFormulas.triangle, currentPhase: phaseTextField.floatValue, frequency: frequencyTextField.floatValue, amplitude: amplitudeTextField.floatValue)
        case 3:
            signal = Signal(signalType: SignalFormulas.sawtooth, currentPhase: phaseTextField.floatValue, frequency: frequencyTextField.floatValue, amplitude: amplitudeTextField.floatValue)
        case 4:
            signal = Signal(signalType: SignalFormulas.noise, currentPhase: phaseTextField.floatValue, frequency: frequencyTextField.floatValue, amplitude: amplitudeTextField.floatValue)
        default:
            fatalError()
        }
        
        //отображение сигнала на графике
        for i in 0..<SignalFormulas.frameCount {
            self.appendData(data: ChartDataEntry(x: Double(i), y: Double(signal.getValue())))
            signal.incrementPhase()
        }
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

