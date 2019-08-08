//
//  Exporting.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/10/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

extension Model.Data {
	func export(inWindow window: NSWindow,
							completionHandler: @escaping ((Bool) -> Void) = { _ in }) {
		let savePanel = NSSavePanel()
		savePanel.nameFieldStringValue = Model.shared.configuration.name
		
		savePanel.beginSheetModal(for: window) { state in
			switch state {
			case NSApplication.ModalResponse.OK:
				
				guard let url = savePanel.url else {
					completionHandler(false)
					return
				}
				
				do {
					try self.export(url: url)
					Model.shared.status.dataExported = true
					completionHandler(true)
				} catch {
					completionHandler(false)
				}
			default:
				completionHandler(false)
				break
			}
		}
	}
	
	fileprivate enum ExportError: Error {
		case couldNotEncodeString
	}
	
	fileprivate func export(url: URL) throws {
		try FileManager().createDirectory(at: url,
																			withIntermediateDirectories: false,
																			attributes: nil)
		
		let summaryURL = url
			.appendingPathComponent("Summary")
			.appendingPathExtension("csv")
		let rawDataURL = url
			.appendingPathComponent("Raw")
			.appendingPathExtension("csv")
		
		guard let summaryData = summaryCSVData.data(using: .utf8) else {
			throw ExportError.couldNotEncodeString
		}
		
		guard let rawData = rawCVSData.data(using: .utf8) else {
			throw ExportError.couldNotEncodeString
		}
		
		do {
			try summaryData.write(to: summaryURL)
			try rawData.write(to: rawDataURL)
		} catch {
			print(error)
		}
	}
	
	fileprivate var summaryCSVData: String {
		
		let data = Model.shared.data
		
		func toOutputString(_ value: Double?) -> String {
			guard let value = value else { return "" }
			return String(value)
		}
		
		typealias Row = StatisticsViewController.Row
		
		let grouped = Model.shared.data.measurements.reduce([]) { (result, measurement) -> [[Model.Data.Measurement]] in
			if let index = result.firstIndex(where: { $0[0].measurementNumber == measurement.measurementNumber }) {
				var nextResult = result
				nextResult[index].append(measurement)
				return nextResult
			} else {
				return result + [[measurement]]
			}
		}
		
		let rowData = grouped.map { group -> Row in
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
		
		let rows = rowData.map { (row) -> [String] in
			return [String(row.measurementNumber),
							row.location,
							toOutputString(row.meanResistance),
							toOutputString(row.standardDeviationResistance),
							toOutputString(row.minimumResistance),
							toOutputString(row.maximumResistance),
							toOutputString(row.meanResistivity),
							toOutputString(row.standardDeviationResistivity),
							toOutputString(row.minimumResistivity),
							toOutputString(row.maximumResistivity)]
		}
		
		let header =  [["#", "Location",
										"μ (R) (Ω)", "σ (R) (Ω)", "min (R) (Ω)", "max (R) (Ω)",
										"μ (ρ) (Ω⋅m)", "σ (ρ) (Ω⋅m)", "min (ρ) (Ω⋅m)", "max (ρ) (Ω⋅m)"]]
		
		return (header + rows).cvsFormat
	}
	
	fileprivate var rawCVSData: String {
		let rows = measurements.map { measurement -> [String] in
			let time = String(measurement.time)
			let resistance = measurement.resistance == nil ? "" : String(measurement.resistance!)
			let resistivity = measurement.resistivity == nil ? "" : String(measurement.resistivity!)
			let location = measurement.location
			let measurementNumber = String(measurement.measurementNumber)
			
			return [measurementNumber, location, time, resistance, resistivity]
		}
		
		return ([["Measurement #, Location, Time(s), Resistance(Ω), Resistivity(Ω⋅m)"]] + rows).cvsFormat
	}
}

fileprivate extension Array where Element == [String] {
	var cvsFormat: String {
		return map { $0.joined(separator: ",") }
			.joined(separator: "\n")
	}
}
