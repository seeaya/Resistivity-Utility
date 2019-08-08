//
//  PrimaryViewController FirstResponder.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/8/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

// MARK: Toolbar

extension PrimaryViewController {
	@objc func startMeasurement(_ sender: Any?) {
		Model.shared.startMeasurement()
	}
	
	@objc func stopMeasurement(_ sender: Any?) {
		Model.shared.stopMeasurement()
	}
}

// MARK: Menubar

extension PrimaryViewController {
	@objc func changeTimeUnit(_ sender: NSMenuItem) {
		guard let unit = Model.TimeUnit(rawValue: sender.tag) else { return }
		Model.shared.format.dataTimeUnit = unit
	}
	
	@objc func changeResistanceUnit(_ sender: NSMenuItem) {
		guard let unit = Model.ResistanceUnit(rawValue: sender.tag) else { return }
		Model.shared.format.dataResistanceUnit = unit
	}
	
	@objc func changeDecimalPlaces(_ sender: NSMenuItem) {
		Model.shared.format.decimalPlaces = sender.tag
	}
}

// MARK: Validation

extension PrimaryViewController: NSUserInterfaceValidations {
	func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
		if let menuItem = item as? NSMenuItem {
			guard let action = menuItem.action else { return false }
			
			switch action {
			case #selector(changeTimeUnit(_:)),
					 #selector(changeResistanceUnit(_:)),
					 #selector(changeDecimalPlaces(_:)):
				return true
			default:
				return true
			}
		}
		return false
	}
}
