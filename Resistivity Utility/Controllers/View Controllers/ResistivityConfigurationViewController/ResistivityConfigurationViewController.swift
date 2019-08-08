//
//  ResistivityConfigurationViewController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/8/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

class ResistivityConfigurationViewController: NSViewController {
	
	@IBOutlet weak var thicknessTextField: NSTextField!
	@IBOutlet weak var thicknessCorrectionFactorTextField: NSTextField!
	@IBOutlet weak var finiteWidthCorrectionFactorTextField: NSTextField!
	
	override func viewDidLoad() {
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(modelDidChange),
																					 name: .modelDidChange,
																					 object: self)
		
		modelDidChange()
	}
	
	@objc func modelDidChange() {
		if let calculator = Model.shared.configuration.resistivityCalculator as? ResistivityCalculator {
			thicknessTextField.doubleValue = calculator.thickness
			thicknessCorrectionFactorTextField.doubleValue = calculator.thicknessCorrectionFactor
			finiteWidthCorrectionFactorTextField.doubleValue = calculator.finiteWidthCorrectionFactor
		}
	}
	
	@IBAction func doneButtonPressed(_ sender: NSButton) {
		Model.shared.configuration.resistivityCalculator = ResistivityCalculator(thickness: thicknessTextField.doubleValue, thicknessCorrectionFactor: thicknessCorrectionFactorTextField.doubleValue, finiteWidthCorrectionFactor: finiteWidthCorrectionFactorTextField.doubleValue)
		dismiss(self)
	}
	
	@IBAction func infoButtonPressed(_ sender: NSButton) {
		guard let url = URL(string: "http://four-point-probes.com/finite-size-corrections-for-4-point-probe-measurements/") else { return }
		NSWorkspace.shared.open(url)
	}
	
	
}

