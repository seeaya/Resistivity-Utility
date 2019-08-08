//
//  DiscardDataWarningViewController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/9/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

class DiscardDataWarningViewController: NSViewController {
	
	@IBAction func cancelButtonPressed(_ sender: NSButton) {
		dismiss(self)
	}
	
	@IBAction func discardButtonPressed(_ sender: NSButton) {
		Model.shared.data.measurements = []
		dismiss(self)
	}
	
	@IBAction func exportButtonPressed(_ sender: NSButton) {
		// Export data
		if let window = view.window {
			Model.shared.data.export(inWindow: window) { [weak self] success in
				guard let self = self else { return }
				
				if success {
					Model.shared.data.measurements = []
					self.dismiss(self)
				}
			}
		}
	}
}
