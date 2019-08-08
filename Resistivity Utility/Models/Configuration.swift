//
//  Configuration.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/8/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation

extension Model {
	struct Configuration: Codable {
		// Measurement configuration
		var delayType: DelayType = .delay
		var delay: TimeInterval = 2.0
		var measurementCount: Int = 5
		var resistivityCalculator: ResistivityCalculator?
		
		func save() {
			UserDefaults.standard.set(delayType.rawValue, forKey: "config-delayType")
			UserDefaults.standard.set(delay, forKey: "config-delay")
			UserDefaults.standard.set(measurementCount, forKey: "config-count")
			UserDefaults.standard.set(resistivityCalculator != nil, forKey: "config-calcResistivity")
			UserDefaults.standard.set(measurementNumber, forKey: "config-number")
		}
		
		init() {
			if let delayTypeRawValue = UserDefaults.standard.object(forKey: "config-delayType") as? Int, let delayType = DelayType(rawValue: delayTypeRawValue) {
				self.delayType = delayType
			} else {
				self.delayType = .delay
			}
			if let delay = UserDefaults.standard.object(forKey: "config-delay") as? Double {
				self.delay = delay
			} else {
				self.delay = 2.0
			}
			if let count = UserDefaults.standard.object(forKey: "config-count") as? Int {
				measurementCount = count
			} else {
				measurementCount = 0
			}
			if let shouldCalculateResistivity = UserDefaults.standard.object(forKey: "config-calcResistivity") as? Bool {
				if shouldCalculateResistivity {
					resistivityCalculator = ResistivityCalculator()
				} else {
					resistivityCalculator = nil
				}
			} else {
				resistivityCalculator = nil
			}
			if let measurementNumber = UserDefaults.standard.object(forKey: "config-number") as? Int {
				self.measurementNumber = measurementNumber
			} else {
				measurementNumber = 0
			}
		}
		
		// Export configuration
		var name = ""
		var location = ""
		var measurementNumber = 0
	}
}
