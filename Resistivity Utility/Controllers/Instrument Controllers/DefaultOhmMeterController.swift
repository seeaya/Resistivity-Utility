//
//  DefaultOhmMeterController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/3/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation
import SwiftVISA

class DefaultOhmMeterController: OhmMeterController {
	static var minimumDelay: UInt32 = 2_000_000
	
	private var instrument: MessageBasedInstrument
	
	// MARK: Dispatch queue
	
	var dispatchQueue: DispatchQueue {
		return instrument.dispatchQueue
	}
	
	// MARK: Return mode
	
	var returnMode: ReturnMode {
		willSet {
			if newValue != returnMode {
				flushOldData(for: newValue)
			}
		}
	}
	
	required init?(identifier: String) {
		guard let im = InstrumentManager.default else { return nil }
		guard let instrument = try? im.makeInstrument(identifier: identifier) as? MessageBasedInstrument else {
			return nil
		}
		
		self.instrument = instrument
		
		self.returnMode = .identifier
		
		flushOldData(for: returnMode)
	}
	
	// MARK: Interface
	
	func getIdentifier() throws -> String {
		returnMode = .identifier
		return try instrument.query("*IDN?\n", as: String.self, decoder: StringDecoder())
	}
	
	func getResistance() throws -> Double {
		returnMode = .resistivity
		return try instrument.query("MEAS:FRES?\n", as: Double.self, decoder: DoubleDecoder())
	}
	
	// MARK: Internals
	
	// The instrument often sends back old data − to make sure that the old data is at least compatible with the new data, query some new data until new data will be returned
	private func flushOldData(for returnMode: ReturnMode) {
		switch returnMode {
		case .identifier:
			for _ in 0..<3 {
				_ = try? instrument.query("*IDN?\n", as: String.self)
				usleep(DefaultOhmMeterController.minimumDelay)
			}
		case .resistivity:
			for _ in 0..<3 {
				_ = try? instrument.query("MEAS:FRES?\n", as: String.self)
				usleep(DefaultOhmMeterController.minimumDelay)
			}
		}
	}
	
	func flushData() {
		flushOldData(for: .resistivity)
	}
}

// MARK: Custom Decoding

extension DefaultOhmMeterController {
	private struct DoubleDecoder: VISADecoder {
		func decode(_ string: String) throws -> Double {
			let fixedString = try StringDecoder().decode(string)
			return try Double.decode(visaString: fixedString)
		}
	}
	
	private struct StringDecoder: VISADecoder {
		func decode(_ string: String) throws -> String {
			var fixedString = string
			
			if string.hasPrefix("1`") {
				fixedString = String(string.dropFirst(2))
			}
			
			while fixedString.hasSuffix("\n") {
				fixedString = String(fixedString.dropLast())
			}
			
			return fixedString
		}
	}
}
