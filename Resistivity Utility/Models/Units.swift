//
//  Units.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/8/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation

extension Model {
	enum TimeUnit: Int, Codable {
		case microSeconds = 0
		case milliSeconds
		case seconds
		case minutes
		case hours
	}
	
	enum ResistanceUnit: Int, Codable {
		case nanoOhm = 0
		case microOhm
		case milliOhm
		case ohm
		case kiloOhm
		case megaOhm
		case gigaOhm
	}
	
	enum ResistivityUnit: Int, Codable {
		case ohmMeter = 0
		case ohmCentimeter
	}
}

// MARK: Conversions

extension Model.TimeUnit {
	func convert(seconds: TimeInterval) -> Double {
		switch self {
		case .microSeconds:
			return seconds * 1_000_000.0
		case .milliSeconds:
			return seconds * 1_000.0
		case .seconds:
			return seconds
		case .minutes:
			return seconds / 60.0
		case .hours:
			return seconds / 3600.0
		}
	}
	
	func convertToSeconds(_ time: Double) -> TimeInterval {
		switch self {
		case .microSeconds:
			return time / 1_000_000.0
		case .milliSeconds:
			return time / 1_000.0
		case .seconds:
			return time
		case .minutes:
			return time * 60.0
		case .hours:
			return time * 3600.0
		}
	}
}

extension Model.ResistanceUnit {
	func convert(ohms: Double) -> Double {
		switch self {
		case .nanoOhm:
			return ohms * 1_000_000_000.0
		case .microOhm:
			return ohms * 1_000_000.0
		case .milliOhm:
			return ohms * 1_000.0
		case .ohm:
			return ohms
		case .kiloOhm:
			return ohms / 1_000.0
		case .megaOhm:
			return ohms / 1_000_000.0
		case .gigaOhm:
			return ohms / 1_000_000_000.0
		}
	}
	
	func convertToOhms(_ resistance: Double) -> Double {
		switch self {
		case .nanoOhm:
			return resistance / 1_000_000_000.0
		case .microOhm:
			return resistance / 1_000_000.0
		case .milliOhm:
			return resistance / 1_000.0
		case .ohm:
			return resistance
		case .kiloOhm:
			return resistance * 1_000.0
		case .megaOhm:
			return resistance * 1_000_000.0
		case .gigaOhm:
			return resistance * 1_000_000_000.0
		}
	}
}

extension Model.ResistivityUnit {
	func convert(ohmMeters: Double) -> Double {
		switch self {
		case .ohmMeter:
			return ohmMeters
		case .ohmCentimeter:
			return ohmMeters * 100
		}
	}
	
	func convertToOhmMeters(_ resistivity: Double) -> Double {
		switch self {
		case .ohmMeter:
			return resistivity
		case .ohmCentimeter:
			return resistivity / 100
		}
	}
}

// MARK: Symbols

extension Model.TimeUnit {
	var symbol: String {
		switch self {
		case .microSeconds:
			return "μs"
		case .milliSeconds:
			return "ms"
		case .seconds:
			return "s"
		case .minutes:
			return "min"
		case .hours:
			return "hr"
		}
	}
}

extension Model.ResistanceUnit {
	var symbol: String {
		switch self {
		case .nanoOhm:
			return "nΩ"
		case .microOhm:
			return "μΩ"
		case .milliOhm:
			return "mΩ"
		case .ohm:
			return "Ω"
		case .kiloOhm:
			return "kΩ"
		case .megaOhm:
			return "MΩ"
		case .gigaOhm:
			return "GΩ"
		}
	}
}

extension Model.ResistivityUnit {
	var symbol: String {
		switch self {
		case .ohmMeter:
			return "Ω⋅m"
		case .ohmCentimeter:
			return "Ω⋅cm"
		}
	}
}
