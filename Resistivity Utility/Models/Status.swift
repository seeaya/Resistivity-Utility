//
//  Status.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/8/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation

extension Model {
	struct Status {
		var isMeasuring = false
		var isMeasuringHealth = false
		var dataExported = false
		var currentBatchMeasurementsCompleted = 0
		
		var hasCheckedHealthThisSession = false
		
		var instrumentConnection = InstrumentConnection.unknown
		
		var timer: Timer?
		var workItem: DispatchWorkItem?
		var healthWorkItem: DispatchWorkItem?
		
		fileprivate let instrumentConnectionQueue = DispatchQueue(label: "Instrument Connection Test", qos: .userInitiated)
	}
}

extension Model.Status {
	enum InstrumentConnection {
		case testing
		case successful
		case unsuccessful
		case unknown
	}
}

extension Model.Status {
	func testInstrumentConnection() {
		Model.shared.status.instrumentConnection = .testing
		
		let identifier = Model.shared.preferences.visaAddress
		instrumentConnectionQueue.async {
			if let controller = Model.makeOhmMeterController(identifier: identifier) {
				// Could create controller
				DispatchQueue.main.async {
					Model.shared.ohmMeterController = controller
					Model.shared.status.instrumentConnection = .successful
				}
			} else {
				// Could not create controller
				DispatchQueue.main.async {
					Model.shared.ohmMeterController = nil
					Model.shared.status.instrumentConnection = .unsuccessful
				}
			}
		}
	}
}
