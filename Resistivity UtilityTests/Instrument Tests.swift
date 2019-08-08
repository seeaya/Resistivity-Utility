//
//  Resistivity_UtilityTests.swift
//  Resistivity UtilityTests
//
//  Created by Connor Barnes on 7/3/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import XCTest
import SwiftVISA
@testable import Resistivity_Utility

class Resistivity_UtilityTests: XCTestCase {
	
	var controller: DefaultOhmMeterController!
	
	override func setUp() {
		
		continueAfterFailure = false
		
		let id = "USB0::0x0403::0x6001::PX3I4TV9::RAW"
		guard let controller = DefaultOhmMeterController(identifier: id) else {
			XCTFail()
			return
		}
		
		self.controller = controller
		
		continueAfterFailure = true
	}
	
	func testInstrumentIdentification() {
		guard let identifier = try? controller.getIdentifier() else {
			XCTFail()
			return
		}

		XCTAssertEqual(identifier, "HEWLETT-PACKARD,34420A,0,10.0-5.0-3.0")
	}
	
	func testGetResistance() {
		XCTAssertNoThrow(try controller.getResistance())
		usleep(DefaultOhmMeterController.minimumDelay)
		XCTAssertNotNil(try? controller.getResistance())
	}
	
}
