//
//  RawDataViewController+NSTableViewDelegate.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/19/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

extension RawDataViewController: NSTableViewDelegate, NSTableViewDataSource {
	func numberOfRows(in tableView: NSTableView) -> Int {
		return Model.shared.data.measurements.count
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let measurement = Model.shared.data.measurements[row]
		
		switch tableColumn?.identifier.rawValue {
		case "MeasurementNumberColumn":
			return makeMeasurementNumberCell(measurement: measurement)
		case "LocationColumn":
			return makeLocationCell(measurement: measurement)
		case "TimeColumn":
			return makeTimeCell(measurement: measurement)
		case "ResistanceColumn":
			return makeResistanceCell(measurement: measurement)
		case "ResistivityColumn":
			return makeResistivityCell(measurement: measurement)
		default:
			return nil
		}
	}
	
	// MARK: Cells
	private func makeTimeCell(measurement: Model.Data.Measurement) -> NSTableCellView? {
		// Have the tableview make the cell
		let identifier = NSUserInterfaceItemIdentifier("TimeCell")
		guard let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView else {
			return nil
		}
		
		// Get the time in the correct units & format
		let time = Model.shared.format.dataTimeUnit.convert(seconds: measurement.time)
		let formattedTime = Style.default.tableNumberFormatter.string(from: NSNumber(value: time)) ?? String(time)
		cell.textField?.stringValue = "\(formattedTime) \(Model.shared.format.dataTimeUnit.symbol)"
		
		// Set textfield style to use monospaced numbers
		cell.textField?.font = Style.default.monospacedNumberFont
		
		return cell
	}
	
	private func makeResistanceCell(measurement: Model.Data.Measurement) -> NSTableCellView? {
		// Have the tableview make the cell
		let identifier = NSUserInterfaceItemIdentifier("ResistivityCell")
		guard let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView else {
			return nil
		}
		
		// Return empty cells for measurements that returned no resistance
		guard let resistanceOhms = measurement.resistance else {
			return nil
		}
		
		// Get the resistivity in the correct units & format
		let resistance = Model.shared.format.dataResistanceUnit.convert(ohms: resistanceOhms)
		let formattedResistance = Style.default.tableNumberFormatter.string(from: NSNumber(value: resistance)) ?? String(resistance)
		cell.textField?.stringValue = "\(formattedResistance) \(Model.shared.format.dataResistanceUnit.symbol)"
		
		// Set textfield style to use monospaced numbers
		cell.textField?.font = Style.default.monospacedNumberFont
		
		return cell
	}
	
	private func makeMeasurementNumberCell(measurement: Model.Data.Measurement) -> NSTableCellView? {
		let identifier = NSUserInterfaceItemIdentifier("MeasurementNumberCell")
		guard let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView else {
			return nil
		}
		
		let measurementNumber = measurement.measurementNumber
		cell.textField?.stringValue = "\(measurementNumber)"
		
		// Set textfield style to use monospaced numbers
		cell.textField?.font = Style.default.monospacedNumberFont
		
		return cell
	}
	
	private func makeLocationCell(measurement: Model.Data.Measurement) -> NSTableCellView? {
		let identifier = NSUserInterfaceItemIdentifier("LocationCell")
		guard let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView else {
			return nil
		}
		
		let location = measurement.location
		cell.textField?.stringValue = location
		
		return cell
	}
	
	private func makeResistivityCell(measurement: Model.Data.Measurement) -> NSTableCellView? {
		let identifier = NSUserInterfaceItemIdentifier("ResistivityCell")
		guard let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView else {
			return nil
		}
		
		// Return empty cells for measurements that returned no resistivity
		guard let resistivityOhmMeters = measurement.resistivity else {
			return nil
		}
		
		// Get the resistivity in the correct units & format
		let resistivity = Model.shared.format.dataResistivityUnit.convert(ohmMeters: resistivityOhmMeters)
		let formattedResistivity = Style.default.tableNumberFormatter.string(from: NSNumber(value: resistivity)) ?? String(resistivity)
		cell.textField?.stringValue = "\(formattedResistivity) \(Model.shared.format.dataResistivityUnit.symbol)"
		
		// Set textfield style to use monospaced numbers
		cell.textField?.font = Style.default.monospacedNumberFont
		
		return cell
	}
}
