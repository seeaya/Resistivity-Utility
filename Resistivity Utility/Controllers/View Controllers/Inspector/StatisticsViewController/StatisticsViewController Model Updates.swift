//
//  StatisticsViewController Model Updates.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 8/7/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

extension StatisticsViewController {
	@objc func modelDidChange() {
		makeRows()
		updateContextualMenus()
		tableView.reloadData()
	}
	
	fileprivate func updateContextualMenus() {
		// Update resistivity unit menu to show checkmark
		resistanceUnitMenu.items.forEach { $0.state = .off }
		resistanceUnitMenu.item(withTag: Model.shared.format.dataResistanceUnit.rawValue)?.state = .on
		
		// Update time unit menu to show checkmark
		timeUnitMenu.items.forEach { $0.state = .off }
		timeUnitMenu.item(withTag: Model.shared.format.dataTimeUnit.rawValue)?.state = .on
		
		// Update decimal places menu to show checkmark
		decimalPlacesMenu.items.forEach { $0.state = .off }
		decimalPlacesMenu.item(withTag: Model.shared.format.decimalPlaces)?.state = .on
	}
	
	fileprivate func makeRows() {
		// Group measurements by number (already sorted by this)
		
		let grouped = Model.shared.data.measurements.reduce([]) { (result, measurement) -> [[Model.Data.Measurement]] in
			if let index = result.firstIndex(where: { $0[0].measurementNumber == measurement.measurementNumber }) {
				var nextResult = result
				nextResult[index].append(measurement)
				return nextResult
			} else {
				return result + [[measurement]]
			}
		}
		
		self.rows = grouped.map { group -> Row in
			let resistances = group.compactMap { $0.resistance }
			let resistivities = group.compactMap { $0.resistivity }
			
			return Row(measurementNumber: group[0].measurementNumber,
								 location: group[0].location,
								 meanResistance: resistances.mean,
								 standardDeviationResistance: resistances.standardDeviation,
								 minimumResistance: resistances.min(),
								 maximumResistance: resistances.max(),
								 meanResistivity: resistivities.mean,
								 standardDeviationResistivity: resistivities.standardDeviation,
								 minimumResistivity: resistivities.min(),
								 maximumResistivity: resistivities.max())
		}
	}
}
