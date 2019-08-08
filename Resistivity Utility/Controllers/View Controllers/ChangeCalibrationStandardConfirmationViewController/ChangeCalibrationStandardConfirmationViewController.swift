//
//  ChangeCalibrationStandardConfirmationViewController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 8/5/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

class ChangeCalibrationStandardConfirmationViewController: NSViewController {
	var newExpectedValue: Double!
	var newResistanceUnit: Model.ResistanceUnit!
	
	override func dismiss(_ viewController: NSViewController) {
		if viewController === self {
			if let presenting = presentingViewController {
				presenting.dismiss(parent)
			}
		}
		
		
		super.dismiss(viewController)
	}
	
	@IBAction func cancelButtonPressed(_ sender: NSButton) {
		dismiss(self)
	}
	
	@IBAction func changeButtonPressed(_ sender: NSButton) {
		Model.shared.healthData.expectedCalibrationValue = newExpectedValue
		Model.shared.format.healthResistanceUnit = newResistanceUnit
		Model.shared.healthData.data = []
		dismiss(self)
	}
}
