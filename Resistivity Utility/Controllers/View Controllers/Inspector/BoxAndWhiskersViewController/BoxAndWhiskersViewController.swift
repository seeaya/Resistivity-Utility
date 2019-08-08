//
//  BoxAndWhiskersViewController.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/28/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

class BoxAndWhiskersViewController: NSViewController {
	
	@IBOutlet weak var resistivityView: NSView!
	
	@IBOutlet weak var resistanceBoxAndWhiskersView: BoxAndWhiskersView!
	@IBOutlet weak var resistivityBoxAndWhiskersView: BoxAndWhiskersView!
	
	@IBOutlet weak var resistanceLabelStackView: NSStackView!
	@IBOutlet weak var resistivityLabelStackView: NSStackView!
	
	@IBOutlet weak var resistanceLabel0: NSTextField!
	@IBOutlet weak var resistanceLabel1: NSTextField!
	@IBOutlet weak var resistanceLabel2: NSTextField!
	@IBOutlet weak var resistanceLabel3: NSTextField!
	@IBOutlet weak var resistanceLabel4: NSTextField!
	@IBOutlet weak var resistanceLabel5: NSTextField!
	
	@IBOutlet weak var resistivityLabel0: NSTextField!
	@IBOutlet weak var resistivityLabel1: NSTextField!
	@IBOutlet weak var resistivityLabel2: NSTextField!
	@IBOutlet weak var resistivityLabel3: NSTextField!
	@IBOutlet weak var resistivityLabel4: NSTextField!
	@IBOutlet weak var resistivityLabel5: NSTextField!
	
	var resistanceLabels: [NSTextField] = []
	
	var resistivityLabels: [NSTextField] = []
	
	override func viewDidLoad() {
		resistanceLabels = [resistanceLabel0,
												resistanceLabel1,
												resistanceLabel2,
												resistanceLabel3,
												resistanceLabel4,
												resistanceLabel5]
		
		resistivityLabels = [resistivityLabel0,
												 resistivityLabel1,
												 resistivityLabel2,
												 resistivityLabel3,
												 resistivityLabel4,
												 resistivityLabel5]
		
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(modelDidChange),
																					 name: .modelDidChange,
																					 object: nil)
		
		modelDidChange()
	}
	
	@objc func modelDidChange() {
		resistanceBoxAndWhiskersView.min = Model.shared.data.minResistance
		resistanceBoxAndWhiskersView.lowerQuartile = Model.shared.data.firstQuartileResistance
		resistanceBoxAndWhiskersView.median = Model.shared.data.medianResistance
		resistanceBoxAndWhiskersView.upperQuartile = Model.shared.data.thirdQuartileResistance
		resistanceBoxAndWhiskersView.max = Model.shared.data.maxResistance
		
		resistanceLabels.forEach { $0.isHidden = true }
		
		axisInfoIf:
		if let maxResistance = Model.shared.data.maxResistance,
			let minResistance = Model.shared.data.minResistance {
			guard let resistanceAxisInfo = AxisInfo(max: maxResistance,
																							min: minResistance) else { break axisInfoIf }
			
			resistanceBoxAndWhiskersView.axisMin = resistanceAxisInfo.minimum
			resistanceBoxAndWhiskersView.axisMax = resistanceAxisInfo.maximum
			
			guard (0...6).contains(resistanceAxisInfo.labels.count) else {
				resistanceBoxAndWhiskersView.tickCount = nil
				break axisInfoIf
			}
			
			resistanceBoxAndWhiskersView.tickCount = resistanceAxisInfo.labels.count
			
			for (index, value) in resistanceAxisInfo.labels.enumerated() {
				resistanceLabels[index].isHidden = false
				
				let factor = 1_000_000_000.0
				
				let convertedResistance = Model.shared.format.dataResistanceUnit.convert(ohms: value)
				
				let formattedResistance = round(convertedResistance * factor) / factor
				
				let unitSymbol = Model.shared.format.dataResistanceUnit.symbol
				resistanceLabels[index].stringValue = "\(formattedResistance) \(unitSymbol)"
			}
		}
		
		resistanceBoxAndWhiskersView.setNeedsDisplay(resistivityBoxAndWhiskersView.bounds)
		
		resistivityBoxAndWhiskersView.min = Model.shared.data.minResistivity
		resistivityBoxAndWhiskersView.lowerQuartile = Model.shared.data.firstQuartileResistivity
		resistivityBoxAndWhiskersView.median = Model.shared.data.medianResistivity
		resistivityBoxAndWhiskersView.upperQuartile = Model.shared.data.thirdQuartileResistivity
		resistivityBoxAndWhiskersView.max = Model.shared.data.maxResistivity
		
		resistivityLabels.forEach { $0.isHidden = true }
		
		axisInfoIf:
		if let maxResistivity = Model.shared.data.maxResistivity,
			let minResistivity = Model.shared.data.minResistivity {
			guard let resistivityAxisInfo = AxisInfo(max: maxResistivity,
																							min: minResistivity) else { break axisInfoIf }
			
			resistivityBoxAndWhiskersView.axisMin = resistivityAxisInfo.minimum
			resistivityBoxAndWhiskersView.axisMax = resistivityAxisInfo.maximum
			
			guard (0...6).contains(resistivityAxisInfo.labels.count) else {
				resistivityBoxAndWhiskersView.tickCount = nil
				break axisInfoIf
			}
			
			resistivityBoxAndWhiskersView.tickCount = resistivityAxisInfo.labels.count
			
			for (index, value) in resistivityAxisInfo.labels.enumerated() {
				resistivityLabels[index].isHidden = false
				
				let factor = 1_000_000_000.0
				
				let convertedResistivity = Model.shared.format.dataResistivityUnit.convert(ohmMeters: value)
				
				let formattedResistivity = round(convertedResistivity * factor) / factor
				
				let unitSymbol = Model.shared.format.dataResistivityUnit.symbol
				resistivityLabels[index].stringValue = "\(formattedResistivity) \(unitSymbol)"
			}
		}
		
		resistivityBoxAndWhiskersView.setNeedsDisplay(resistivityBoxAndWhiskersView.bounds)
	}
	
	struct AxisInfo {
		var minimum: Double
		var maximum: Double
		
		var subdivisions: Int
		var labels: [Double]
		
		init?(max: Double, min: Double) {
			let rawMin = min
			let rawMax = max
			
			let range = rawMax - rawMin
			
			guard range > 0 else { return nil }
			
			let decimalPlace = floor(log10(range))
			
			let factor = pow(10, decimalPlace)
			
			let graphMin = floor(rawMin / factor) * factor
			let graphMax = ceil(rawMax / factor) * factor
			
			let delta = graphMax - graphMin
			
			let deltaRank = Int(round(delta / factor))
			
			let labelCount: Int
			
			switch deltaRank {
			case 2:
				subdivisions = 10
				labelCount = 2
				minimum = graphMin
			case 3:
				subdivisions = 6
				labelCount = 3
				minimum = graphMin
			case 4:
				subdivisions = 8
				labelCount = 4
				minimum = graphMin
			case 5:
				subdivisions = 10
				labelCount = 5
				minimum = graphMin
			case 6:
				subdivisions = 6
				labelCount = 3
				minimum = graphMin
			case 7:
				subdivisions = 8
				labelCount = 4
				minimum = graphMin - factor
			case 8:
				subdivisions = 8
				labelCount = 4
				minimum = graphMin
			case 9:
				subdivisions = 9
				labelCount = 3
				minimum = graphMin
			case 10:
				subdivisions = 10
				labelCount = 5
				minimum = graphMin
			case 11:
				subdivisions = 6
				labelCount = 3
				minimum = graphMin - factor
			default:
				return nil
			}
			
			maximum = graphMax
			
			let dLabel = (maximum - minimum) / Double(labelCount)
			
			labels = Array(stride(from: minimum, through: maximum, by: dLabel))
		}
	}
}
