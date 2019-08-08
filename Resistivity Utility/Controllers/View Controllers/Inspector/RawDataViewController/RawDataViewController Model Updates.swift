//
//  RawDataViewController Model Updates.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/19/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

extension RawDataViewController {
	@objc func modelDidChange() {
		updateContextualMenus()
		// Update the table view
		if Model.shared.updateConfiguration.shouldUpdateTableView {
			tableView.reloadData()
		}
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
}
