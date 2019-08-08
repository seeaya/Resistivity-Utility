//
//  MeasurementViewController Model Updates.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/19/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

extension MeasurementViewController {
	
	@objc func modelDidChange() {
		updateMeasurementConfiguration()
		updateResistivityConfiguration()
		updateNumberFormatter()
		updateMainMenu()
		updateStatisticLabels()
		updateExportConfiguration()
	}
	
	fileprivate func updateMeasurementConfiguration() {
		// Update the delay type and value
		
		let isMeasuring = Model.shared.status.isMeasuring || Model.shared.status.isMeasuringHealth
		
		delayTypePopUpButton.isEnabled = !isMeasuring
		delayTextField.isEnabled = !isMeasuring
		delayTimeUnitPopUpButton.isEnabled = !isMeasuring
		measurementCountTextField.isEnabled = !isMeasuring
		
		if editingTextField !== delayTextField {
			switch Model.shared.configuration.delayType {
			case .delay:
				delayTypePopUpButton.selectItem(withTag: 0)
			case .timeInterval:
				delayTypePopUpButton.selectItem(withTag: 1)
			}
			delayTextField.doubleValue = Model.shared.format.delayTimeUnit.convert(seconds: Model.shared.configuration.delay)
		}
		
		// Update the time unit pop up
		let timeUnitTag = Model.shared.format.delayTimeUnit.rawValue
		delayTimeUnitPopUpButton.selectItem(withTag: timeUnitTag)
		
		// Update the measurement count
		if editingTextField !== measurementCountTextField {
			measurementCountTextField.integerValue = Model.shared.configuration.measurementCount
		}
	}
	
	fileprivate func updateResistivityConfiguration() {
		let isMeasuring = Model.shared.status.isMeasuring || Model.shared.status.isMeasuringHealth
		
		calculateResistivityButton.isEnabled = !isMeasuring
		configureResistivityButton.isEnabled = !isMeasuring
		
		let shouldCalculateResistivity = Model.shared.configuration.resistivityCalculator != nil
		
		calculateResistivityButton.state = shouldCalculateResistivity ? .on : .off
		configureResistivityButton.isEnabled = shouldCalculateResistivity && !isMeasuring
	}
	
	fileprivate func updateNumberFormatter() {
		// Update number formatter
		let formatter = NumberFormatter()
		formatter.allowsFloats = true
		formatter.alwaysShowsDecimalSeparator = Model.shared.format.decimalPlaces != 0
		formatter.hasThousandSeparators = true
		formatter.minimumFractionDigits = Model.shared.format.decimalPlaces
		formatter.maximumFractionDigits = Model.shared.format.decimalPlaces
		formatter.minimumIntegerDigits = 1
		
		Style.default.tableNumberFormatter = formatter
	}
	
	fileprivate func updateMainMenu() {
		guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return }
		
		appDelegate.updateTimeUnitMenu(tag: Model.shared.format.dataTimeUnit.rawValue)
		appDelegate.updateDecimalPlacesMenu(tag: Model.shared.format.decimalPlaces)
		appDelegate.updateResistanceUnitMenu(tag: Model.shared.format.dataResistanceUnit.rawValue)
	}
	
	fileprivate func updateStatisticLabels() {
		// Resistance Statistics
		
		if let meanResistance = Model.shared.data.meanResistance {
			let convertedMean = Model.shared.format.dataResistanceUnit
				.convert(ohms: meanResistance)
			let formattedMean = Style.default.tableNumberFormatter
				.string(from: NSNumber(value: convertedMean)) ?? String(convertedMean)
			
			meanResistanceLabel.stringValue = "\(formattedMean) \(Model.shared.format.dataResistanceUnit.symbol)"
		} else {
			meanResistanceLabel.stringValue = "N/A"
		}
		
		if let sdResistance = Model.shared.data.standardDeviationResistance {
			let convertedSD = Model.shared.format.dataResistanceUnit
				.convert(ohms: sdResistance)
			let formattedSD = Style.default.tableNumberFormatter
				.string(from: NSNumber(value: convertedSD)) ?? String(convertedSD)
			
			standardDeviationResistanceLabel.stringValue = "\(formattedSD) \(Model.shared.format.dataResistanceUnit.symbol)"
		} else {
			standardDeviationResistanceLabel.stringValue = "N/A"
		}
		
		if let minResistance = Model.shared.data.minResistance {
			let convertedMin = Model.shared.format.dataResistanceUnit
				.convert(ohms: minResistance)
			let formattedMin = Style.default.tableNumberFormatter
				.string(from: NSNumber(value: convertedMin)) ?? String(convertedMin)
			
			minimumResistanceLabel.stringValue = "\(formattedMin) \(Model.shared.format.dataResistanceUnit.symbol)"
		} else {
			minimumResistanceLabel.stringValue = "N/A"
		}
		
		if let maxResistance = Model.shared.data.maxResistance {
			let convertedMax = Model.shared.format.dataResistanceUnit
				.convert(ohms: maxResistance)
			let formattedMax = Style.default.tableNumberFormatter
				.string(from: NSNumber(value: convertedMax)) ?? String(convertedMax)
			
			maximumResistanceLabel.stringValue = "\(formattedMax) \(Model.shared.format.dataResistanceUnit.symbol)"
		} else {
			maximumResistanceLabel.stringValue = "N/A"
		}
		
		// Resistivity Statistics
		
		// If we are not taking resistivity measurements, don't show their statistics
		resistivityStatisticsView.isHidden = (Model.shared.configuration.resistivityCalculator == nil && Model.shared.data.measurements.filter { $0.resistivity != nil }.isEmpty )
		
		if let meanResistance = Model.shared.data.meanResistivity {
			let convertedMean = Model.shared.format.dataResistivityUnit
				.convert(ohmMeters: meanResistance)
			let formattedMean = Style.default.tableNumberFormatter
				.string(from: NSNumber(value: convertedMean)) ?? String(convertedMean)
			
			meanResistivityLabel.stringValue = "\(formattedMean) \(Model.shared.format.dataResistivityUnit.symbol)"
		} else {
			meanResistivityLabel.stringValue = "N/A"
		}
		
		if let sdResistance = Model.shared.data.standardDeviationResistivity {
			let convertedSD = Model.shared.format.dataResistivityUnit
				.convert(ohmMeters: sdResistance)
			let formattedSD = Style.default.tableNumberFormatter
				.string(from: NSNumber(value: convertedSD)) ?? String(convertedSD)
			
			standardDeviationResistivityLabel.stringValue = "\(formattedSD) \(Model.shared.format.dataResistivityUnit.symbol)"
		} else {
			standardDeviationResistivityLabel.stringValue = "N/A"
		}
		
		if let minResistance = Model.shared.data.minResistivity {
			let convertedMin = Model.shared.format.dataResistivityUnit
				.convert(ohmMeters: minResistance)
			let formattedMin = Style.default.tableNumberFormatter
				.string(from: NSNumber(value: convertedMin)) ?? String(convertedMin)
			
			minimumResistivityLabel.stringValue = "\(formattedMin) \(Model.shared.format.dataResistivityUnit.symbol)"
		} else {
			minimumResistivityLabel.stringValue = "N/A"
		}
		
		if let maxResistance = Model.shared.data.maxResistivity {
			let convertedMax = Model.shared.format.dataResistivityUnit
				.convert(ohmMeters: maxResistance)
			let formattedMax = Style.default.tableNumberFormatter
				.string(from: NSNumber(value: convertedMax)) ?? String(convertedMax)
			
			maximumResistivityLabel.stringValue = "\(formattedMax) \(Model.shared.format.dataResistivityUnit.symbol)"
		} else {
			maximumResistivityLabel.stringValue = "N/A"
		}
	}
	
	fileprivate func updateExportConfiguration() {
		let isMeasuring = Model.shared.status.isMeasuring || Model.shared.status.isMeasuringHealth
		
		nameTextField.isEnabled = !isMeasuring
		locationTextField.isEnabled = !isMeasuring
		
		// Update the name field
		if editingTextField !== nameTextField {
			nameTextField.stringValue = Model.shared.configuration.name
		}
		
		// Update the location field
		if editingTextField !== locationTextField {
			locationTextField.stringValue = Model.shared.configuration.location
		}
		
		// Update the measurement number
		measurementNumberLabel.integerValue = Model.shared.configuration.measurementNumber
		
		// Update button enabling
		// If there are no measurements or there is a measurement in progress, don't allow saving or discarding
		let shouldEnableButton = !(Model.shared.data.measurements.count == 0 || isMeasuring)
		discardButton.isEnabled = shouldEnableButton
		exportButton.isEnabled = shouldEnableButton
	}
}
