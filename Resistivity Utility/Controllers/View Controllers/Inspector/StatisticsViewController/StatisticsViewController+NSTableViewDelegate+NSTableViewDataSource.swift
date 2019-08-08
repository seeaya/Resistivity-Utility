//
//  StatisticsViewController+NSTableViewDelegate+NSTableViewDataSource.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 8/7/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

extension StatisticsViewController: NSTableViewDelegate, NSTableViewDataSource {
	func numberOfRows(in tableView: NSTableView) -> Int {
		return rows.count
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let column = tableColumn else { return nil }
		
		let rowData = rows[row]
		
		switch column.identifier.rawValue {
		case "sNumber":
			return makeNumberCell(row: rowData)
		case "sMeanR":
			return makeResistanceCell(resistance: rowData.meanResistance)
		case "sSDR":
			return makeResistanceCell(resistance: rowData.standardDeviationResistance)
		case "sMinR":
			return makeResistanceCell(resistance: rowData.minimumResistance)
		case "sMaxR":
			return makeResistanceCell(resistance: rowData.maximumResistance)
		case "sMeanRho":
			return makeResistivityCell(resistivity: rowData.meanResistivity)
		case "sSDRho":
			return makeResistivityCell(resistivity: rowData.standardDeviationResistivity)
		case "sMinRho":
			return makeResistivityCell(resistivity: rowData.minimumResistivity)
		case "sMaxRho":
			return makeResistivityCell(resistivity: rowData.maximumResistivity)
		default:
			return nil
		}
	}
	
	fileprivate func makeNumberCell(row: Row) -> NSTableCellView? {
		// Have the table make the cell
		let identifier = NSUserInterfaceItemIdentifier("sNumberCell")
		guard let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView else {
			return nil
		}
		
		cell.textField?.integerValue = row.measurementNumber
		
		// Set textfield style to use monospaced numbers
		cell.textField?.font = Style.default.monospacedNumberFont
		
		return cell
	}
	
	fileprivate func makeResistanceCell(resistance: Double?) -> NSTableCellView? {
		// Have the tableview make the cell
		let identifier = NSUserInterfaceItemIdentifier("sMeanRCell")
		guard let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView else {
			return nil
		}
		
		// Return empty cells for measurements that returned no resistance
		guard let resistanceOhms = resistance else {
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
	
	fileprivate func makeResistivityCell(resistivity: Double?) -> NSTableCellView? {
		let identifier = NSUserInterfaceItemIdentifier("sMeanRhoCell")
		guard let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView else {
			return nil
		}
		
		// Return empty cells for measurements that returned no resistivity
		guard let resistivityOhmMeters = resistivity else {
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
