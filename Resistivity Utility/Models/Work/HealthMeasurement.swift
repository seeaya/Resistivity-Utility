//
//  HealthMeasurement.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 8/5/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation

extension Model {
	func startHealthMeasurement() {
		guard let controller = ohmMeterController else { return }
		
		// Post notifications to set state on toolbar buttons
		
		let notifications = [Notification(name: Notification.Name.disableMeasuring),
												 Notification(name: Notification.Name.enableStopping)]
		
		notifications.forEach { NotificationCenter.default.post($0) }
		
		// Get configuration values
		let measurementCount = 5
		
		status.isMeasuringHealth = true
		
		let startTime = Date()
		
		var resistances: [Double] = []
		
		let workItem = DispatchWorkItem { [weak self] in
			guard let self = self else { return }
			
			// Measure resistance
			guard let resistance = try? controller.getResistance() else { return }
			
			// Add measurement list of measurements
			resistances.append(resistance)
		}
		
		DispatchQueue.main.async { [weak self] in
			if let self = self {
				self.status.healthWorkItem = workItem
			} else {
				workItem.cancel()
			}
		}
		
		// Calculate time to wait until next measurement
		
		let delay = 2.5
		
		var measurementsCompleted = 0
		
		func performMeasurements() {
			// Perform the work item (this performs a single measurement)
			
			if measurementsCompleted == 0 {
				controller.flushData()
			}
			
			let startTime = Date()
			
			workItem.perform()
			// Unless the measurement batch has been cancelled or all of the measurements have been completed, schedule the next peasurement
			if !workItem.isCancelled {
				DispatchQueue.main.async {
					Model.shared.status.currentBatchMeasurementsCompleted = resistances.count
				}
				if resistances.count < measurementCount {
					DispatchQueue.main.async { [weak self] in
						let endTime = Date()
						let timeElapsed = endTime.timeIntervalSince(startTime)
						let timeToWait = delay - timeElapsed
						// Schedule the next measurement
						let timer = Timer.scheduledTimer(withTimeInterval: timeToWait, repeats: false) { _ in
							controller.dispatchQueue.async {
								performMeasurements()
							}
						}
						self?.status.timer = timer
					}
				} else {
					
					DispatchQueue.main.async { [weak self] in
						let mean = resistances.reduce(0.0, +) / Double(resistances.count)
						
						let datapoint = Model.HealthData.DataPoint(date: Date(), value: mean)
						
						Model.shared.healthData.data.append(datapoint)
						Model.shared.status.hasCheckedHealthThisSession = true
						self?.stopHealthMeasurement()
					}
				}
			}
		}
		
		controller.dispatchQueue.async {
			performMeasurements()
		}
		
	}
	
	func stopHealthMeasurement() {
		status.healthWorkItem?.cancel()
		status.timer = nil
		
		Model.shared.status.currentBatchMeasurementsCompleted = 0
		healthMeasurementCompleted()
	}
	
	fileprivate func healthMeasurementCompleted() {
		guard status.isMeasuringHealth || status.healthWorkItem != nil else { return }
		// Make sure the work item was completed otherwise there is a new measurement
		guard status.healthWorkItem?.isCancelled ?? true else { return }
		
		status.isMeasuringHealth = false
		status.healthWorkItem = nil
		
		let notifications = [Notification(name: Notification.Name.enableMeasuring),
												 Notification(name: Notification.Name.disableStopping)]
		
		notifications.forEach { NotificationCenter.default.post($0) }
	}
}
