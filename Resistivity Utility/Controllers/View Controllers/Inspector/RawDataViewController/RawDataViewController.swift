//
//  RawDataViewController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/19/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

class RawDataViewController: NSViewController {
	// MARK: Outlets
	@IBOutlet weak var tableView: NSTableView!
	
	// Contextual Menus
	@IBOutlet weak var decimalPlacesMenu: NSMenu!
	@IBOutlet weak var resistanceUnitMenu: NSMenu!
	@IBOutlet weak var timeUnitMenu: NSMenu!
	
	// MARK: Setup
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(modelDidChange),
																					 name: .modelDidChange,
																					 object: nil)
		
		modelDidChange()
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

