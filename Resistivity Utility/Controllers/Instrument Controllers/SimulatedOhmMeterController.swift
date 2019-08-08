//
//  SimulatedOhmMeterController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/4/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation

class SimulatedOhmMeterController: OhmMeterController {
	static var minimumDelay: UInt32 = 1_000_000
	
	var dispatchQueue = DispatchQueue(label: "Simulated Ohm Meter", qos: .userInitiated)
	
	var returnMode: ReturnMode
	
	required init?(identifier: String) {
		returnMode = .identifier
	}
	
	func getIdentifier() throws -> String {
		return "Simulated Ohm Meter"
	}
	
	func getResistance() throws -> Double {
		return Double.random(in: 1.0e-4...1.9e-4)
	}
	
	func flushData() {
		
	}
}
