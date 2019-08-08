//
//  DiscardDataMeasureWarningViewController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/9/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

class DiscardDataMeasureWarningViewController: NSViewController {
	
	var shouldBeginMeasuring = false
	
	@IBAction func cancelButtonPressed(_ sender: NSButton) {
		dismiss(self)
	}
	
	@IBAction func discardButtonPressed(_ sender: NSButton) {
		shouldBeginMeasuring = true
		Model.shared.data.measurements = []
		dismiss(self)
	}
	
	@IBAction func exportButtonPressed(_ sender: NSButton) {
		// Export data
		if let window = view.window {
			Model.shared.data.export(inWindow: window) { [weak self] success in
				guard let self = self else { return }
				
				if success {
					self.shouldBeginMeasuring = true
				}
				self.dismiss(self)
			}
		}
	}
	
	override func viewDidDisappear() {
		if shouldBeginMeasuring {
			Model.shared.data.measurements = []
			Model.shared.startMeasurement()
		}
	}
}
