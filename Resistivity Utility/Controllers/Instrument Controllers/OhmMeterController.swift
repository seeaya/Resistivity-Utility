//
//  OhmMeterController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/4/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation

protocol OhmMeterController: class {
	static var minimumDelay: UInt32 { get }
	
	var dispatchQueue: DispatchQueue { get }
	
	var returnMode: ReturnMode { get set }
	
	init?(identifier: String)
	
	func getIdentifier() throws -> String
	
	func getResistance() throws -> Double
	
	func flushData()
}

enum ReturnMode {
	case identifier
	case resistivity
}
