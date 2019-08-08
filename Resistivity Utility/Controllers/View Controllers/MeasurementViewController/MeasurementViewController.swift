//
//  MeasurementViewController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/19/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

class MeasurementViewController: NSViewController {
	// MARK: Outlets
	
	// Measurement configuration
	@IBOutlet weak var delayTypePopUpButton: NSPopUpButton!
	@IBOutlet weak var delayTextField: NSTextField!
	@IBOutlet weak var delayTimeUnitPopUpButton: NSPopUpButton!
	@IBOutlet weak var measurementCountTextField: NSTextField!
	
	// Resistivity configuration
	@IBOutlet weak var calculateResistivityButton: NSButton!
	@IBOutlet weak var configureResistivityButton: NSButton!
	
	// Export
	@IBOutlet weak var nameTextField: NSTextField!
	@IBOutlet weak var locationTextField: NSTextField!
	@IBOutlet weak var measurementNumberLabel: NSTextField!
	@IBOutlet weak var discardButton: NSButton!
	@IBOutlet weak var exportButton: NSButton!
	
	@IBOutlet weak var meanResistanceLabel: NSTextField!
	@IBOutlet weak var standardDeviationResistanceLabel: NSTextField!
	@IBOutlet weak var minimumResistanceLabel: NSTextField!
	@IBOutlet weak var maximumResistanceLabel: NSTextField!
	
	@IBOutlet weak var resistivityStatisticsView: NSView!
	
	@IBOutlet weak var meanResistivityLabel: NSTextField!
	@IBOutlet weak var standardDeviationResistivityLabel: NSTextField!
	@IBOutlet weak var minimumResistivityLabel: NSTextField!
	@IBOutlet weak var maximumResistivityLabel: NSTextField!
	
	// MARK: Set up
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(modelDidChange),
																					 name: .modelDidChange,
																					 object: nil)
		
		formatStatisticLabels()
		modelDidChange()
	}
	
	// MARK: Text Fields
	
	var editingTextField: NSTextField?
	
	// MARK: Actions
	
	// Buttons
	
	@IBAction func discardButtonPressed(_ sender: NSButton) {
		if Model.shared.data.canSafelyDiscard {
			Model.shared.data.measurements = []
		} else {
			guard let storyboard = NSStoryboard.main else { return }
			guard let destination = storyboard.instantiateController(withIdentifier: "DiscardDataWarningSheetViewController") as? DiscardDataWarningViewController else { return }
			presentAsSheet(destination)
		}
	}
	
	@IBAction func exportButtonPressed(_ sender: NSButton) {
		guard let window = view.window else { return }
		Model.shared.data.export(inWindow: window)
	}
	
	@IBAction func calculateResistivityButtonPressed(_ sender: NSButton) {
		switch sender.state {
		case .on:
			Model.shared.configuration.resistivityCalculator = ResistivityCalculator()
		case .off:
			Model.shared.configuration.resistivityCalculator = nil
		default:
			break
		}
	}
	
	// Pop ups
	
	@IBAction func delayTypePopUpButtonDidChange(_ sender: NSPopUpButton) {
		switch sender.selectedTag() {
		case 0:
			Model.shared.configuration.delayType = .delay
		case 1:
			Model.shared.configuration.delayType = .timeInterval
		default:
			break
		}
	}
	
	@IBAction func delayTimeUnitPopUpButtonDidChange(_ sender: NSPopUpButton) {
		guard let timeUnit = Model.TimeUnit(rawValue: sender.selectedTag()) else { return }
		Model.shared.format.delayTimeUnit = timeUnit
	}
}
