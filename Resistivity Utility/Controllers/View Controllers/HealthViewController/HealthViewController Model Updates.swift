//
//  HealthViewController Model Updates.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 8/5/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

extension HealthViewController {
	@objc func modelDidChange() {
		updateValues()
		updateStatus()
		updateChart()
		updateProgressIndicator()
	}
	
	fileprivate func updateValues() {
		let resistanceUnit = Model.shared.format.healthResistanceUnit
		let unitSymbol = resistanceUnit.symbol
		
		
		let expectedValue = Model.shared.healthData.expectedCalibrationValue
		let convertedExpectedValue = resistanceUnit.convert(ohms: expectedValue)
		let formattedExpectedValue = Style.default.tableNumberFormatter.string(from: NSNumber(value: convertedExpectedValue)) ?? String(convertedExpectedValue)
		expectedValueLabel.stringValue = "\(formattedExpectedValue) \(unitSymbol)"
		
		guard let actualValue = (Model.shared.healthData.data.last)?.value else {
			actualValueLabel.stringValue = "No data"
			deviationLabel.stringValue = "No data"
			return
		}
		let convertedActualValue = resistanceUnit.convert(ohms: actualValue)
		let formattedActualValue = Style.default.tableNumberFormatter.string(from: NSNumber(value: convertedActualValue)) ?? String(convertedActualValue)
		actualValueLabel.stringValue = "\(formattedActualValue) \(unitSymbol)"
		
		let deviation = convertedActualValue - convertedExpectedValue
		let formattedDeviation = Style.default.tableNumberFormatter.string(from: NSNumber(value: deviation)) ?? String(deviation)
		let percentDeviation = abs(deviation) / convertedExpectedValue * 100
		let formattedPercentDeviation = Style.default.tableNumberFormatter.string(from: NSNumber(value: percentDeviation)) ?? String(percentDeviation)
		deviationLabel.stringValue = "\(formattedDeviation) \(unitSymbol) (\(formattedPercentDeviation)%)"
	}
	
	fileprivate func updateStatus() {
		guard Model.shared.status.hasCheckedHealthThisSession else {
			statusImage.image = NSImage(named: NSImage.statusNoneName)
			statusLabel.stringValue = "Not checked"
			return
		}
		guard let actualValue = Model.shared.healthData.data.last?.value else {
			statusImage.image = NSImage(named: NSImage.statusNoneName)
			statusLabel.stringValue = "Not checked"
			return
		}
		let expectedValue = Model.shared.healthData.expectedCalibrationValue
		let percentDeviation = abs(actualValue - expectedValue) / expectedValue * 100.0
		
		switch percentDeviation {
		case 0..<1.0:
			statusImage.image = NSImage(named: NSImage.statusAvailableName)
			statusLabel.stringValue = "Good health"
		case 1.0..<5.0:
			statusImage.image = NSImage(named: NSImage.statusPartiallyAvailableName)
			statusLabel.stringValue = "Okay health"
		default:
			statusImage.image = NSImage(named: NSImage.statusUnavailableName)
			statusLabel.stringValue = "Bad health"
		}
	}
	
	fileprivate func updateChart() {
		guard Model.shared.healthData.data.count > 1 else {
			noHistoricalDataLabel.isHidden = false
			scatterPlot.dataPoints = []
			return
		}
		
		noHistoricalDataLabel.isHidden = true
		
		let startDate = Model.shared.healthData.data.first!.date
		
		let timePoints = Model.shared.healthData.data.map { (x: $0.date.timeIntervalSince(startDate),y: $0.value) }
		
		let maxX = timePoints.last!.x
		
		let minY = timePoints.min { $0.y < $1.y }!.y
		let maxY = timePoints.max { $0.y < $1.y }!.y
		
		scatterPlot.dataPoints = timePoints
		scatterPlot.axisMinX = 0.0
		scatterPlot.axisMaxX = maxX
		scatterPlot.axisMinY = minY
		scatterPlot.axisMaxY = maxY
		
		scatterPlot.setNeedsDisplay(scatterPlot.bounds)
		
		// Labels
		let unit = Model.shared.format.dataResistanceUnit
		
		let minYConverted = unit.convert(ohms: minY)
		let minYFormatted = Style.default.tableNumberFormatter.string(from: NSNumber(value: minYConverted)) ?? String(minYConverted)
		
		minPlotLabel.stringValue = "\(minYFormatted) \(unit.symbol)"
		
		let maxYConverted = unit.convert(ohms: maxY)
		let maxYFormatted = Style.default.tableNumberFormatter.string(from: NSNumber(value: maxYConverted)) ?? String(maxYConverted)
		
		maxPlotLabel.stringValue = "\(maxYFormatted) \(unit.symbol)"
	}
	
	fileprivate func updateProgressIndicator() {
		guard Model.shared.status.isMeasuringHealth || Model.shared.status.isMeasuring else {
			measureHealthButton.isEnabled = true
			editButton.isEnabled = true
			return
		}
		
		measureHealthButton.isEnabled = false
		editButton.isEnabled = false
		
		guard Model.shared.status.isMeasuringHealth else { return }
		
		measurementProgressIndicator.minValue = 0.0
		measurementProgressIndicator.maxValue = 5.0
		measurementProgressIndicator.doubleValue = Double(Model.shared.status.currentBatchMeasurementsCompleted)
	}
}
