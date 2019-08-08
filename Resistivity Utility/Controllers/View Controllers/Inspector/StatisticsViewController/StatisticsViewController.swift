//
//  StatisticsViewController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 8/7/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

class StatisticsViewController: NSViewController {
	@IBOutlet weak var tableView: NSTableView!
	
	// Contextual Menus
	@IBOutlet weak var decimalPlacesMenu: NSMenu!
	@IBOutlet weak var resistanceUnitMenu: NSMenu!
	@IBOutlet weak var timeUnitMenu: NSMenu!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(modelDidChange),
																					 name: .modelDidChange,
																					 object: nil)
		
		modelDidChange()
	}
	
	var rows: [Row] = []
	
	struct Row {
		var measurementNumber: Int
		
		var location: String
		
		var meanResistance: Double?
		var standardDeviationResistance: Double?
		var minimumResistance: Double?
		var maximumResistance: Double?
		
		var meanResistivity: Double?
		var standardDeviationResistivity: Double?
		var minimumResistivity: Double?
		var maximumResistivity: Double?
		
	}
	
	// MARK: Actions
	
	// Menus
	@IBAction func tableTimeUnitPressed(_ sender: NSMenuItem) {
		guard let unit = Model.TimeUnit(rawValue: sender.tag) else { return }
		Model.shared.format.dataTimeUnit = unit
	}
	
	@IBAction func tableResistanceUnitPressed(_ sender: NSMenuItem) {
		guard let unit = Model.ResistanceUnit(rawValue: sender.tag) else { return }
		Model.shared.format.dataResistanceUnit = unit
	}
	
	@IBAction func tableDecimalPlacesPressed(_ sender: NSMenuItem) {
		Model.shared.format.decimalPlaces = sender.tag
	}
}
