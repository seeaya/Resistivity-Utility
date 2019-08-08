//
//  Measurement.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/3/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Foundation

extension Model {
	func startMeasurement() {
		
		guard let controller = ohmMeterController else { return }
		
		configuration.measurementNumber += 1
		
		// Post notifications to set state on toolbar buttons
		
		let notifications = [Notification(name: Notification.Name.disableMeasuring),
												 Notification(name: Notification.Name.enableStopping)]
		
		notifications.forEach { NotificationCenter.default.post($0) }
		
		// Get configuration values
		let measurementCount = self.configuration.measurementCount
		let delayType = self.configuration.delayType
		let delayValue = self.configuration.delay
		
		status.isMeasuring = true
		status.dataExported = false
		
		let startTime = Date()
		
		Model.shared.data.startTime = startTime
		
		let workItem = DispatchWorkItem { [weak self] in
			guard let self = self else { return }
			
			// Measure resistance
			let resistance = try? controller.getResistance()
			
			// Calculate change in time
			let currentTime = Date()
			let timeDifference = currentTime.timeIntervalSince(startTime)
			
			// Add measurement to model's list of measurements
			let newMeasurement = Model.Data.Measurement(time: timeDifference, resistance: resistance)
			DispatchQueue.main.sync { [weak self] in
				self?.data.measurements.append(newMeasurement)
			}
		}
		
		DispatchQueue.main.async { [weak self] in
			if let self = self {
				self.status.workItem = workItem
			} else {
				workItem.cancel()
			}
		}
		
		// Calculate time to wait until next measurement
		
		let delay: Double
		
		switch delayType {
		case .delay:
			delay = delayValue
		case .timeInterval:
			delay = delayValue / Double(measurementCount)
		}
		
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
				measurementsCompleted += 1
				DispatchQueue.main.async {
					Model.shared.status.currentBatchMeasurementsCompleted += 1
				}
				if measurementsCompleted < measurementCount {
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
						self?.stopMeasurement()
					}
				}
			}
		}
		
		controller.dispatchQueue.async {
			performMeasurements()
		}
	}
	
	func stopMeasurement() {
		status.workItem?.cancel()
		status.timer = nil
		
		Model.shared.data.completedGroupedMeasurements += Model.shared.status.currentBatchMeasurementsCompleted
		
		Model.shared.status.currentBatchMeasurementsCompleted = 0
		
		measurementCompleted()
	}
	
	fileprivate func measurementCompleted() {
		guard status.isMeasuring || status.workItem != nil else { return }
		// Make sure the work item was completed otherwise there is a new measurement
		guard status.workItem?.isCancelled ?? true else { return }
		
		data.endTime = Date()
		status.isMeasuring = false
		status.workItem = nil
		
		let notifications = [Notification(name: Notification.Name.enableMeasuring),
												 Notification(name: Notification.Name.disableStopping)]
		
		notifications.forEach { NotificationCenter.default.post($0) }
	}
}
