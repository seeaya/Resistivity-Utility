//
//  RawDataViewController FirstResponder.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/19/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

extension RawDataViewController {
	@objc func delete(_ sender: Any?) {
		let selectedIndexes = tableView.selectedRowIndexes
		
		tableView.removeRows(at: selectedIndexes, withAnimation: .slideUp)
		
		for index in selectedIndexes.sorted().reversed() {
			Model.shared.withoutUpdating(.tableView) {
				Model.shared.data.measurements.remove(at: index)
			}
		}
	}
}


// MARK: Validation

extension RawDataViewController: NSUserInterfaceValidations {
	func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
		if let menuItem = item as? NSMenuItem {
			guard let action = menuItem.action else { return false }
			
			switch action {
			case #selector(delete(_:)):
				return tableView.selectedRowIndexes.count > 0
			default:
				return true
			}
		}
		return false
	}
}
