//
//  PrimaryWindowController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/4/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

class PrimaryWindowController: NSWindowController {
	@IBOutlet weak var measureToolbarButton: NSButton!
	@IBOutlet weak var stopToolbarButton: NSButton!
	
	override func windowDidLoad() {
		registerNotifications()
	}
	
	// MARK: Toolbar notifications
	
	@objc func disableMeasureButton(_ notification: Notification) {
		measureToolbarButton.isEnabled = false
	}
	
	@objc func enableMeasureButton(_ notification: Notification) {
		measureToolbarButton.isEnabled = true
	}
	
	@objc func disableStopButton(_ notification: Notification) {
		stopToolbarButton.isEnabled = false
	}
	
	@objc func enableStopButton(_ notification: Notification) {
		stopToolbarButton.isEnabled = true
	}
}

// MARK: Notifications

extension PrimaryWindowController {
	fileprivate func registerNotifications() {
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(disableMeasureButton(_:)),
																					 name: NSNotification.Name.disableMeasuring,
																					 object: nil)
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(enableMeasureButton(_:)),
																					 name: NSNotification.Name.enableMeasuring,
																					 object: nil)
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(disableStopButton(_:)),
																					 name: NSNotification.Name.disableStopping,
																					 object: nil)
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(enableStopButton(_:)),
																					 name: NSNotification.Name.enableStopping,
																					 object: nil)
	}
}
