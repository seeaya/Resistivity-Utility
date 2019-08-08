//
//  GeneralPreferencesViewController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/22/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

class GeneralPreferencesViewController: NSViewController {
	@IBOutlet weak var visaAddressTextField: NSTextField!
	@IBOutlet weak var visaAddressValidProgressIndicator: NSProgressIndicator!
	@IBOutlet weak var visaAddressValidImageIndicator: NSImageView!
	@IBOutlet weak var testConnectionButton: NSButton!
	
	override func viewDidLoad() {
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(modelDidChange),
																					 name: .modelDidChange,
																					 object: nil)
		
		modelDidChange()
	}
	
	@IBAction func testConnectionButtonPressed(_ sender: NSButton) {
		Model.shared.status.testInstrumentConnection()
	}
	
	
	@objc func modelDidChange() {
		updateVisaAddress()
	}
	
	fileprivate func updateVisaAddress() {
		switch Model.shared.status.instrumentConnection {
		case .successful:
			visaAddressTextField.isEnabled = true
			testConnectionButton.isHidden = false
			visaAddressValidProgressIndicator.isHidden = true
			visaAddressValidProgressIndicator.stopAnimation(self)
			visaAddressValidImageIndicator.image = NSImage(named: NSImage.statusAvailableName)
		case .unsuccessful:
			visaAddressTextField.isEnabled = true
			testConnectionButton.isHidden = false
			visaAddressValidProgressIndicator.isHidden = true
			visaAddressValidProgressIndicator.stopAnimation(self)
			visaAddressValidImageIndicator.image = NSImage(named: NSImage.statusUnavailableName)
		case .testing:
			visaAddressTextField.isEnabled = false
			testConnectionButton.isHidden = true
			visaAddressValidProgressIndicator.isHidden = false
			visaAddressValidProgressIndicator.startAnimation(self)
			visaAddressValidImageIndicator.image = NSImage(named: NSImage.statusNoneName)
		case .unknown:
			visaAddressTextField.isEnabled = true
			testConnectionButton.isHidden = false
			visaAddressValidProgressIndicator.isHidden = true
			visaAddressValidProgressIndicator.stopAnimation(self)
			visaAddressValidImageIndicator.image = NSImage(named: NSImage.statusNoneName)
		}
	}
}

extension GeneralPreferencesViewController: NSControlTextEditingDelegate {
	func controlTextDidChange(_ obj: Notification) {
		Model.shared.preferences.visaAddress = visaAddressTextField.stringValue
		Model.shared.status.instrumentConnection = .unknown
	}
}
