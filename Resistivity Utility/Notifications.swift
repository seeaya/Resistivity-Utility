//
//  Notifications.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/4/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation

extension NSNotification.Name {
	static let disableMeasuring = NSNotification.Name("disableMeasuring")
	static let enableMeasuring = NSNotification.Name("enableMeasuring")
	static let disableStopping = NSNotification.Name("disableStopping")
	static let enableStopping = NSNotification.Name("enableStopping")
	static let modelDidChange = NSNotification.Name("modelDidChange")
}
