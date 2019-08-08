//
//  Data.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/8/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation

extension Model {
	struct Data: Codable {
		var measurements: [Measurement] = [] {
			didSet {
				Model.shared.status.dataExported = false
			}
		}
		var startTime: Date?
		var endTime: Date?
		
		var completedGroupedMeasurements = 0
		
		var canSafelyDiscard: Bool {
			// If there are no measurements, or the data has already been exported there is no need to warn the user abound discarding data.
			return Model.shared.data.measurements.isEmpty || Model.shared.status.dataExported
		}
	}
}

// MARK: Measurement

extension Model.Data {
	struct Measurement: Codable {
		var measurementNumber: Int
		var location: String
		var time: TimeInterval
		var resistance: Double?
		var resistivity: Double?
		
		init(time: TimeInterval, resistance: Double?) {
			measurementNumber = Model.shared.configuration.measurementNumber
			self.time = time
			self.resistance = resistance
			self.location = Model.shared.configuration.location
			
			guard let resistance = resistance else { return }
			guard let calculator = Model.shared.configuration.resistivityCalculator else { return }
			
			resistivity = calculator.resistivity(forResistance: resistance)
		}
	}
}

// MARK: Summary Statistics

extension Model.Data {
	// MARK: Raw
	fileprivate var rawResistances: [Double] {
		return measurements.compactMap { $0.resistance }
	}
	
	fileprivate var rawResistivities: [Double] {
		return measurements.compactMap { $0.resistivity }
	}
	
	// MARK: Resistance
	
	var meanResistance: Double? {
		return rawResistances.mean
	}
	
	var standardDeviationResistance: Double? {
		return rawResistances.standardDeviation
	}
	
	var minResistance: Double? {
		return rawResistances.min()
	}
	
	var maxResistance: Double? {
		return rawResistances.max()
	}
	
	var medianResistance: Double? {
		return rawResistances.median
	}
	
	var firstQuartileResistance: Double? {
		return rawResistances.firstQuartile
	}
	
	var thirdQuartileResistance: Double? {
		return rawResistances.thirdQuartile
	}
	
	// MARK: Resistivity
	
	var meanResistivity: Double? {
		return rawResistivities.mean
	}
	
	var standardDeviationResistivity: Double? {
		return rawResistivities.standardDeviation
	}
	
	var minResistivity: Double? {
		return rawResistivities.min()
	}
	
	var maxResistivity: Double? {
		return rawResistivities.max()
	}
	
	var medianResistivity: Double? {
		return rawResistivities.median
	}
	
	var firstQuartileResistivity: Double? {
		return rawResistivities.firstQuartile
	}
	
	var thirdQuartileResistivity: Double? {
		return rawResistivities.thirdQuartile
	}
}

extension Array where Element == Double {
	var mean: Double? {
		guard !isEmpty else { return nil }
		return reduce(0.0, +) / Double(count)
	}
	
	var standardDeviation: Double? {
		guard let mean = mean else { return nil }
		return reduce(0.0) { $0 + pow(abs(mean - $1), 2.0) } / Double(count)
	}
	
	private var assumedSortedMedian: Double? {
		guard !isEmpty else { return nil }
		
		if count.isMultiple(of: 2) {
			// even
			return (self[count / 2] + self[count / 2 - 1]) / 2.0
		} else {
			//odd
			return self[count / 2]
		}
	}
	
	var median: Double? {
		guard !isEmpty else { return nil }
		
		let sorted = self.sorted()
		
		return sorted.assumedSortedMedian
	}
	
	var firstQuartile: Double? {
		guard !isEmpty else { return nil }
		
		let sorted = self.sorted()
		
		return Array(sorted[0..<(count / 2)]).assumedSortedMedian
	}
	
	var thirdQuartile: Double? {
		guard !isEmpty else { return nil }
		
		let sorted = self.sorted()
		
		return Array(sorted[(count / 2)..<count]).assumedSortedMedian
	}
}
