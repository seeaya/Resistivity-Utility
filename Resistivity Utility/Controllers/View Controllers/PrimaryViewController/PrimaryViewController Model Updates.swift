//
//  PrimaryViewController Model Updates.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/4/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

extension PrimaryViewController {
	
	@objc func modelDidChange() {
		updateProgressIndicator()
	}
	
	fileprivate func updateProgressIndicator() {
		if Model.shared.status.isMeasuring {
			measurementProgressIndicator.isHidden = false
			measurementProgressIndicator.isIndeterminate = false
			measurementProgressIndicator.stopAnimation(nil)
			measurementProgressIndicator.maxValue = Double(max(Model.shared.configuration.measurementCount, 0))
			measurementProgressIndicator.doubleValue = Double(Model.shared.data.measurements.count - Model.shared.data.completedGroupedMeasurements)
		} else {
			measurementProgressIndicator.isHidden = true
		}
	}
}
