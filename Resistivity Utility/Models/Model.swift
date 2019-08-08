//
//  Model.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/3/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation

class Model {
	var data = Data() {
		didSet {
			notifyModelDidChange()
		}
	}
	
	var format = Format() {
		didSet {
			format.save()
			notifyModelDidChange()
		}
	}
	
	var configuration = Configuration() {
		didSet {
			configuration.save()
			configuration.resistivityCalculator?.save()
			notifyModelDidChange()
		}
	}
	
	var status = Status() {
		didSet {
			notifyModelDidChange()
		}
	}
	
	var preferences = Preferences() {
		didSet {
			preferences.save()
			notifyModelDidChange()
			ohmMeterController = Model.makeOhmMeterController()
		}
	}
	
	var healthData = HealthData() {
		didSet {
			healthData.save()
			notifyModelDidChange()
		}
	}
	
	var updateConfiguration = UpdateConfiguration()
	
	// Instrument Controller
	var ohmMeterController: OhmMeterController?
	
	// MARK: Singleton
	
	static var shared = Model()
	
	private init() {
		ohmMeterController = Model.makeOhmMeterController()
	}
	
	static func makeOhmMeterController(identifier: String? = nil) -> OhmMeterController? {
		
		let id: String
		
		if let identifier = identifier {
			id = identifier
		} else {
			let defaults = UserDefaults.standard
			
			if let saved = defaults.string(forKey: "visa-address") {
				id = saved
			} else {
				id = "USB0::0x0403::0x6001::PX3I4TV9::RAW"
			}
			
		}
		#if DEBUG
		if Debug.shouldUseSimulatedInstrument {
			return SimulatedOhmMeterController(identifier: id)
		} else {
			return DefaultOhmMeterController(identifier: id)
		}
		#else
		return DefaultOhmMeterController(identifier: id)
		#endif
	}
	
	func save() {
		format.save()
		configuration.save()
		preferences.save()
		healthData.save()
	}
}

// MARK: Delay Type

extension Model {
	enum DelayType: Int, Codable {
		case delay
		case timeInterval
	}
}

// MARK: Change Notification

extension Model {
	func notifyModelDidChange() {
		let notification = Notification(name: .modelDidChange)
		NotificationCenter.default.post(notification)
	}
}

// MARK: Prevent updating

extension Model {
	struct UpdateConfiguration {
		fileprivate(set) var shouldUpdateTableView = true
	}
	
	enum ViewUpdate {
		case tableView
	}
	
	func withoutUpdating(_ viewUpdate: ViewUpdate, _ code: () -> Void) {
		updateConfiguration.shouldUpdateTableView = viewUpdate != .tableView
		code()
		updateConfiguration.shouldUpdateTableView = true
	}
}
