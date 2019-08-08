//
//  Preferences.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/20/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation

extension Model {
	struct Preferences: Codable {
		var visaAddress: String
		
		func save() {
			UserDefaults.standard.set(visaAddress, forKey: "pref-visaAddress")
		}
		
		init() {
			if let visaAddress = UserDefaults.standard.string(forKey: "pref-visaAddress") {
				self.visaAddress = visaAddress
			} else {
				visaAddress = "USB0::0x0403::0x6001::PX3I4TV9::RAW"
			}
		}
	}
}
