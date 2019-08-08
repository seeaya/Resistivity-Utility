//
//  MeasurementViewController+NSControlTextEditingDelegate.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/19/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

extension MeasurementViewController: NSControlTextEditingDelegate {
	func controlTextDidChange(_ obj: Notification) {
		guard let textField = obj.object as? NSTextField else { return }
		
		editingTextField = textField
		
		if textField === delayTextField {
			
			guard let textFieldValue = delayTextFieldDoubleValue else { return }
			
			Model.shared.configuration.delay = Model.shared.format.delayTimeUnit.convertToSeconds(textFieldValue)
			
			
		} else if textField === measurementCountTextField {
			Model.shared.configuration.measurementCount = measurementCountTextField.integerValue
		} else if textField === nameTextField {
			Model.shared.configuration.name = nameTextField.stringValue
		} else if textField === locationTextField {
			Model.shared.configuration.location = locationTextField.stringValue
		}
		
	}
	
	func controlTextDidBeginEditing(_ obj: Notification) {
		guard let object = obj.object as? NSTextField else { return }
		editingTextField = object
	}
	
	func controlTextDidEndEditing(_ obj: Notification) {
		editingTextField = nil
	}
}

extension MeasurementViewController {
	// This prevents the field from updating while the user is typing in it
	fileprivate var delayTextFieldDoubleValue: Double? {
		get {
			guard let formatter = delayTextField.formatter as? NumberFormatter else { return -1.0 }
			guard let fieldEditor = delayTextField.currentEditor() else { return delayTextField.doubleValue }
			
			guard let newDouble = formatter.number(from: fieldEditor.string) else { return -1.0 }
			
			return Double(truncating: newDouble)
		}
		set {
			guard let newValue = newValue else { return }
			delayTextField.doubleValue = newValue
		}
	}
	
}
