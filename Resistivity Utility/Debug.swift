//
//  Debug.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/4/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

#if DEBUG
import Cocoa

struct Debug {
	static let shouldUseSimulatedInstrument = true
	static let shouldUseUserDefaults = true
	static let shouldResetUserDefaults = false
	
	fileprivate init() { }
	
	static func applicationDidFinishLaunching() {
		if Debug.shouldResetUserDefaults {
			guard let name = Bundle.main.bundleIdentifier else {
				print("DEBUG - Error: Could not clear user defaults")
				return
			}
			UserDefaults.standard.removePersistentDomain(forName: name)
			UserDefaults.standard.synchronize()
			print("DEBUG - User defaults cleared")
		}
		
		if !Debug.shouldUseUserDefaults {
			print("DEBUG - User defaults are not being used")
		}
	}
}
#endif
