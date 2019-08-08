//
//  AppDelegate.swift
//  Resistivity Measurer
//
//  Created by Connor Barnes on 7/1/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	// MARK: Outlets
	
	@IBOutlet weak var microsecondTimeUnitMenuItem: NSMenuItem!
	@IBOutlet weak var millisecondTimeUnitMenuItem: NSMenuItem!
	@IBOutlet weak var secondTimeUnitMenuItem: NSMenuItem!
	@IBOutlet weak var minuteTimeUnitMenuItem: NSMenuItem!
	@IBOutlet weak var hourTimeUnitMenuItem: NSMenuItem!
	
	@IBOutlet weak var nanoohmResistanceUnitMenuItem: NSMenuItem!
	@IBOutlet weak var microohmResistanceUnitMenuItem: NSMenuItem!
	@IBOutlet weak var milliohmResistanceUnitMenuItem: NSMenuItem!
	@IBOutlet weak var ohmResistanceUnitMenuItem: NSMenuItem!
	@IBOutlet weak var kiloohmResistanceUnitMenuItem: NSMenuItem!
	@IBOutlet weak var megaohmResistanceUnitMenuItem: NSMenuItem!
	@IBOutlet weak var gigaohmResistanceUnitMenuItem: NSMenuItem!
	
	@IBOutlet weak var decimalPlaces0MenuItem: NSMenuItem!
	@IBOutlet weak var decimalPlaces1MenuItem: NSMenuItem!
	@IBOutlet weak var decimalPlaces2MenuItem: NSMenuItem!
	@IBOutlet weak var decimalPlaces3MenuItem: NSMenuItem!
	@IBOutlet weak var decimalPlaces4MenuItem: NSMenuItem!
	@IBOutlet weak var decimalPlaces5MenuItem: NSMenuItem!
	@IBOutlet weak var decimalPlaces6MenuItem: NSMenuItem!
	
	// MARK: Application Events
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		#if DEBUG
		Debug.applicationDidFinishLaunching()
		#endif
	}
}
