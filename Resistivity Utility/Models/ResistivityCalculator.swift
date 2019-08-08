//
//  ResistivityCalculator.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/10/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation

struct ResistivityCalculator: Codable {
	var thickness: Double
	var thicknessCorrectionFactor: Double
	var finiteWidthCorrectionFactor: Double
	
	var t: Double { return thickness }
	var f1: Double { return thicknessCorrectionFactor }
	var f2: Double { return finiteWidthCorrectionFactor }
	
	func resistivity(forResistance resistance: Double) -> Double {
		return Double.pi / log(2) * t * f1 * f2 * resistance
	}
	
	init(thickness: Double, thicknessCorrectionFactor: Double, finiteWidthCorrectionFactor: Double) {
		self.thickness = thickness
		self.thicknessCorrectionFactor = thicknessCorrectionFactor
		self.finiteWidthCorrectionFactor = finiteWidthCorrectionFactor
	}
	
	func save() {
		UserDefaults.standard.set(t, forKey: "rc-t")
		UserDefaults.standard.set(f1, forKey: "rc-f1")
		UserDefaults.standard.set(f2, forKey: "rc-f2")
	}
	
	init() {
		if let t = UserDefaults.standard.object(forKey: "rc-t") as? Double {
			thickness = t
		} else {
			thickness = 1.0
		}
		if let f1 = UserDefaults.standard.object(forKey: "rc-f1") as? Double {
			thicknessCorrectionFactor = f1
		} else {
			thicknessCorrectionFactor = 1.0
		}
		if let f2 = UserDefaults.standard.object(forKey: "rc-f2") as? Double {
			finiteWidthCorrectionFactor = f2
		} else {
			finiteWidthCorrectionFactor = 1.0
		}
	}
}
