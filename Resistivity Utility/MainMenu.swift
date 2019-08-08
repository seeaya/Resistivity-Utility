//
//  MainMenu.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/8/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

extension AppDelegate {
	func updateDecimalPlacesMenu(tag: Int) {
		let menuItems = [decimalPlaces0MenuItem!,
										 decimalPlaces1MenuItem!,
										 decimalPlaces2MenuItem!,
										 decimalPlaces3MenuItem!,
										 decimalPlaces4MenuItem!,
										 decimalPlaces5MenuItem!,
										 decimalPlaces6MenuItem!]
		
		menuItems.forEach { $0.state = .off }
		
		menuItems.first(where: { $0.tag == tag })?.state = .on
	}
	
	func updateTimeUnitMenu(tag: Int) {
		let menuItems = [microsecondTimeUnitMenuItem!,
										 millisecondTimeUnitMenuItem!,
										 secondTimeUnitMenuItem!,
										 minuteTimeUnitMenuItem!,
										 hourTimeUnitMenuItem!]
		
		menuItems.forEach { $0.state = .off }
		
		menuItems.first(where: { $0.tag == tag })?.state = .on
	}
	
	func updateResistanceUnitMenu(tag: Int) {
		let menuItems = [nanoohmResistanceUnitMenuItem!,
										 microohmResistanceUnitMenuItem!,
										 milliohmResistanceUnitMenuItem!,
										 ohmResistanceUnitMenuItem!,
										 kiloohmResistanceUnitMenuItem!,
										 megaohmResistanceUnitMenuItem!,
										 gigaohmResistanceUnitMenuItem!]
		
		menuItems.forEach { $0.state = .off }
		
		menuItems.first(where: { $0.tag == tag })?.state = .on
	}
}
