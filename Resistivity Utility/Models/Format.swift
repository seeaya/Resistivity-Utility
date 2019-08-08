//
//  Format.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/8/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation

extension Model {
	struct Format: Codable {
		var delayTimeUnit: TimeUnit = .seconds
		var dataTimeUnit: TimeUnit = .seconds
		var dataResistanceUnit: ResistanceUnit = .milliOhm
		var dataResistivityUnit: ResistivityUnit = .ohmCentimeter
		var healthResistanceUnit: ResistanceUnit = .milliOhm
		var decimalPlaces: Int = 3
		
		func save() {
			UserDefaults.standard.set(delayTimeUnit.rawValue, forKey: "format-delayTimeUnit")
			UserDefaults.standard.set(dataTimeUnit.rawValue, forKey: "format-dataTimeUnit")
			UserDefaults.standard.set(dataResistanceUnit.rawValue, forKey: "format-dataResistanceUnit")
			UserDefaults.standard.set(dataResistivityUnit.rawValue, forKey: "format-dataResistivityUnit")
			UserDefaults.standard.set(healthResistanceUnit.rawValue, forKey: "format-healthResistanceUnit")
			UserDefaults.standard.set(decimalPlaces, forKey: "format-decimals")
		}
		
		init() {
			if let delayTimeUnitRawValue = UserDefaults.standard.object(forKey: "format-delayTimeUnit") as? Int, let delayTimeUnit = TimeUnit(rawValue: delayTimeUnitRawValue) {
				self.delayTimeUnit = delayTimeUnit
			} else {
				delayTimeUnit = .seconds
			}
			
			if let dataTimeUnitRawValue = UserDefaults.standard.object(forKey: "format-dataTimeUnit") as? Int, let dataTimeUnit = TimeUnit(rawValue: dataTimeUnitRawValue) {
				self.dataTimeUnit = dataTimeUnit
			} else {
				dataTimeUnit = .seconds
			}
			
			if let dataResistanceUnitRawValue = UserDefaults.standard.object(forKey: "format-dataResistanceUnit") as? Int, let dataResistanceUnit = ResistanceUnit(rawValue: dataResistanceUnitRawValue) {
				self.dataResistanceUnit = dataResistanceUnit
			} else {
				dataResistanceUnit = .milliOhm
			}
			
			if let dataResistivityUnitRawValue = UserDefaults.standard.object(forKey: "format-dataResistivityUnit") as? Int, let dataResistivityUnit = ResistivityUnit(rawValue: dataResistivityUnitRawValue) {
				self.dataResistivityUnit = dataResistivityUnit
			} else {
				dataResistivityUnit = .ohmCentimeter
			}
			
			if let healthResistanceUnitRawValue = UserDefaults.standard.object(forKey: "format-healthResistanceUnit") as? Int, let healthResistanceUnit = ResistanceUnit(rawValue: healthResistanceUnitRawValue) {
				self.healthResistanceUnit = healthResistanceUnit
			} else {
				healthResistanceUnit = .milliOhm
			}
			
			if let decimals = UserDefaults.standard.object(forKey: "format-decimals") as? Int {
				decimalPlaces = decimals
			} else {
				decimalPlaces = 3
			}
		}
	}
}
