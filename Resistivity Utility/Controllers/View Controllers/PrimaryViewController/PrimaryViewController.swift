//
//  PrimaryViewController.swift
//  Resistivity Measurer
//
//  Created by Connor Barnes on 7/1/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa
import SwiftVISA

class PrimaryViewController: NSViewController {
	
	// MARK: Outlets
	
	@IBOutlet weak var measurementProgressIndicator: NSProgressIndicator!
	
	// Inspector
	@IBOutlet weak var rawDataInspectorButton: NSButton!
	@IBOutlet weak var graphInspectorButton: NSButton!
	@IBOutlet weak var statisticsInspectorButton: NSButton!
	
	@IBOutlet weak var inspectorTabView: NSTabView!
	
	// MARK: Set up
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(modelDidChange),
																					 name: .modelDidChange,
																					 object: nil)
		
		modelDidChange()
	}
	
	// MARK: Cached images
	
	lazy var rawDataImage = #imageLiteral(resourceName: "Table Icon")
	lazy var rawDataSelectedImage = #imageLiteral(resourceName: "Table Icon Selected")
	lazy var graphImage = #imageLiteral(resourceName: "Graph Icon")
	lazy var graphSelectedImage = #imageLiteral(resourceName: "Graph Icon Selected")
	lazy var statisticsImage = #imageLiteral(resourceName: "Statistics Icon")
	lazy var statisticsSelectedImage = #imageLiteral(resourceName: "Statistics Icon Selected")
	
	@IBAction func rawDataInspectorButtonPressed(_ sender: NSButton) {
		inspectorTabView.selectTabViewItem(at: 0)
		
		rawDataInspectorButton.image = rawDataSelectedImage
		rawDataInspectorButton.contentTintColor = .controlAccentColor
		
		graphInspectorButton.image = graphImage
		graphInspectorButton.contentTintColor = .secondaryLabelColor
		
		statisticsInspectorButton.image = statisticsImage
		statisticsInspectorButton.contentTintColor = .secondaryLabelColor
	}
	
	@IBAction func graphInspectorButtonPressed(_ sender: NSButton) {
		inspectorTabView.selectTabViewItem(at: 1)
		
		rawDataInspectorButton.image = rawDataImage
		rawDataInspectorButton.contentTintColor = .secondaryLabelColor
		
		graphInspectorButton.image = graphSelectedImage
		graphInspectorButton.contentTintColor = .controlAccentColor
		
		statisticsInspectorButton.image = statisticsImage
		statisticsInspectorButton.contentTintColor = .secondaryLabelColor
	}
	
	@IBAction func statisticsInspectorButtonPressed(_ sender: NSButton) {
		inspectorTabView.selectTabViewItem(at: 2)
		
		rawDataInspectorButton.image = rawDataImage
		rawDataInspectorButton.contentTintColor = .secondaryLabelColor
		
		graphInspectorButton.image = graphImage
		graphInspectorButton.contentTintColor = .secondaryLabelColor
		
		statisticsInspectorButton.image = statisticsSelectedImage
		statisticsInspectorButton.contentTintColor = .controlAccentColor
	}
}
