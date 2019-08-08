//
//  HealthViewController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 8/5/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

class HealthViewController: NSViewController {
	@IBOutlet weak var expectedValueLabel: NSTextField!
	@IBOutlet weak var actualValueLabel: NSTextField!
	@IBOutlet weak var deviationLabel: NSTextField!
	@IBOutlet weak var editButton: NSButton!
	
	@IBOutlet weak var statusImage: NSImageView!
	@IBOutlet weak var statusLabel: NSTextField!
	@IBOutlet weak var measureHealthButton: NSButton!
	
	@IBOutlet weak var measurementProgressIndicator: NSProgressIndicator!
	
	@IBOutlet weak var noHistoricalDataLabel: NSTextField!
	@IBOutlet weak var scatterPlot: ScatterPlotView!
	@IBOutlet weak var minPlotLabel: NSTextField!
	@IBOutlet weak var maxPlotLabel: NSTextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(modelDidChange),
																					 name: .modelDidChange,
																					 object: nil)
		
		modelDidChange()
	}
	
	@IBAction func measureHealthButtonPressed(_ sender: NSButton) {
		Model.shared.startHealthMeasurement()
	}
	
}

extension HealthViewController: NSUserInterfaceValidations {
	func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
		if let menuItem = item as? NSMenuItem {
			return menuItem.identifier?.rawValue ?? "" != "deleteMenuItem"
		}
		return false
	}
}
