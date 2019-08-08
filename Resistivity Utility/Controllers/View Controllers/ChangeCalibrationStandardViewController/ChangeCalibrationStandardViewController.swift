//
//  ChangeCalibrationStandardViewController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 8/5/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

class ChangeCalibrationStandardViewController: NSViewController {
	@IBOutlet weak var expectedValueTextField: NSTextField!
	@IBOutlet weak var resistanceUnitPopUpButton: NSPopUpButton!
	@IBOutlet weak var applyButton: NSButton!
	
	var hasBeenEdited = false
	
	override func viewDidLoad() {
		expectedValueTextField.doubleValue = Model.shared.format.healthResistanceUnit.convert(ohms: Model.shared.healthData.expectedCalibrationValue)
		
		resistanceUnitPopUpButton.selectItem(withTag: Model.shared.format.healthResistanceUnit.rawValue)
	}
	
	@IBAction func resistanceUnitPopUpButtonDidChange(_ sender: NSPopUpButton) {
		hasBeenEdited = true
		applyButton.isEnabled = true
	}
	
	@IBAction func cancelButtonPressed(_ sender: NSButton) {
		dismiss(self)
	}
	
	@IBAction func applyButtonPressed(_ sender: NSButton) {
		guard let storyboard = NSStoryboard.main else { return }
		guard let destination = storyboard.instantiateController(withIdentifier: "ChangeCalibrationStandardConfirmationViewController") as? ChangeCalibrationStandardConfirmationViewController else { return }
		
		destination.newResistanceUnit = Model.ResistanceUnit(rawValue: resistanceUnitPopUpButton.selectedTag())!
		destination.newExpectedValue = destination.newResistanceUnit.convertToOhms(expectedValueTextField.doubleValue)
		
		presentAsSheet(destination)
	}
}

extension ChangeCalibrationStandardViewController: NSControlTextEditingDelegate {
	func controlTextDidChange(_ obj: Notification) {
		hasBeenEdited = true
		applyButton.isEnabled = true
	}
}
