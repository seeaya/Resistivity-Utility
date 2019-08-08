//
//  HealthData.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 8/4/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation

extension Model {
	struct HealthData: Codable {
		var data: [DataPoint] = []
		
		var expectedCalibrationValue: Double = 0.0
		
		func save() {
			guard let rawData = try? JSONEncoder().encode(data) else { return }
			UserDefaults.standard.set(rawData, forKey: "health-data")
			
			UserDefaults.standard.set(expectedCalibrationValue, forKey: "health-expected")
		}
		
		init() {
			if let jsonData = UserDefaults.standard.data(forKey: "health-data") {
				if let rawData = try? JSONDecoder().decode([DataPoint].self, from: jsonData) {
					data = rawData
				} else {
					data = []
				}
			} else {
				data = []
			}
			if let expected = UserDefaults.standard.object(forKey: "health-expected") as? Double {
				expectedCalibrationValue = expected
			} else {
				expectedCalibrationValue = 0.0
			}
		}
		
		struct DataPoint: Codable {
			var date: Date
			var value: Double
		}
	}
}
