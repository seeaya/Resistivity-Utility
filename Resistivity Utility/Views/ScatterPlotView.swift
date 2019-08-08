//
//  ScatterPlotView.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 8/4/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

@IBDesignable
class ScatterPlotView: NSView {
	var dataPoints: [(x: Double, y: Double)] = [] {
		didSet {
			minimumX = dataPoints.min { $0.x < $1.x }?.x
			maximumX = dataPoints.max { $0.x < $1.x }?.x
			
			minimumY = dataPoints.min { $0.y < $1.y }?.y
			maximumY = dataPoints.max { $0.y < $1.y }?.y
		}
	}
	
	var minimumX: Double?
	var maximumX: Double?
	
	var minimumY: Double?
	var maximumY: Double?
	
	var axisMinX: Double?
	var axisMaxX: Double?
	
	var axisMinY: Double?
	var axisMaxY: Double?
	
	func relativePoint(x: Double, y: Double, in bounds: CGRect) -> CGPoint {
		let xScaled = CGFloat((x - axisMinX!) / (axisMaxX! - axisMinX!)) * bounds.width + bounds.origin.x
		let yScaled = CGFloat((y - axisMinY!) / (axisMaxY! - axisMinY!)) * bounds.height + bounds.origin.y
		
		return CGPoint(x: xScaled, y: yScaled)
	}
	
	
	@IBInspectable var axisWidth: CGFloat = 12.0
	@IBInspectable var axisStrokeWidth: CGFloat = 2.0
	@IBInspectable var axisColor: NSColor = .labelColor
	
	@IBInspectable var connectionLineStrokeWidth: CGFloat = 2.0
	@IBInspectable var connectionLineColor: NSColor = .controlAccentColor
	
	@IBInspectable var pointRadius: CGFloat = 5.0
	@IBInspectable var pointStrokeWidth: CGFloat = 2.0
	@IBInspectable var pointStrokeColor: NSColor = .controlAccentColor
	@IBInspectable var pointFillColor: NSColor = .windowBackgroundColor
	
	override func draw(_ dirtyRect: NSRect) {
		guard let context = NSGraphicsContext.current?.cgContext else { return }
		
		let pointInset = pointRadius + pointStrokeWidth / 2.0
		
		let xAxisBounds = CGRect(x: bounds.minX + axisWidth,
														 y: bounds.minY,
														 width: bounds.width - axisWidth - pointInset,
														 height: axisWidth)
		
		let yAxisBounds = CGRect(x: bounds.minX,
														 y: bounds.minY + axisWidth,
														 width: axisWidth,
														 height: bounds.height - axisWidth - pointInset)
		
		let axisConnectionBounds = CGRect(x: bounds.minX + axisWidth - axisStrokeWidth,
																			y: bounds.minY + axisWidth - axisStrokeWidth,
																			width: axisStrokeWidth,
																			height: axisStrokeWidth)
		
		let plotBounds = CGRect(x: bounds.minX + axisWidth,
														y: bounds.minY + axisWidth,
														width: bounds.width - axisWidth - pointInset,
														height: bounds.height - axisWidth - pointInset)
		
		drawXAxis(in: context, bounds: xAxisBounds)
		drawYAxis(in: context, bounds: yAxisBounds)
		drawAxisConnection(in: context, bounds: axisConnectionBounds)
		
		guard minimumX != nil,
			minimumY != nil,
			maximumX != nil,
			maximumY != nil,
			axisMinX != nil,
			axisMinY != nil,
			axisMaxX != nil,
			axisMaxY != nil else { return }
		
		if pointRadius > 0.0 {
			for point in dataPoints {
				drawDataPoint(in: context, x: point.x, y: point.y, bounds: plotBounds)
			}
		}
		
		drawConnectionLine(in: context, bounds: plotBounds)
	}
	
	fileprivate func drawXAxis(in context: CGContext, bounds: CGRect) {
		context.setLineWidth(axisStrokeWidth)
		context.setStrokeColor(axisColor.cgColor)
		
		let points = [CGPoint(x: bounds.minX,
													y: bounds.maxY - axisStrokeWidth / 2.0),
									CGPoint(x: bounds.maxX,
													y: bounds.maxY - axisStrokeWidth / 2.0)]
		
		context.strokeLineSegments(between: points)
	}
	
	fileprivate func drawYAxis(in context: CGContext, bounds: CGRect) {
		context.setLineWidth(axisStrokeWidth)
		context.setStrokeColor(axisColor.cgColor)
		
		let points = [CGPoint(x: bounds.maxX - axisStrokeWidth / 2.0,
													y: bounds.minY),
									CGPoint(x: bounds.maxX - axisStrokeWidth / 2.0, y: bounds.maxY)]
		
		
		context.strokeLineSegments(between: points)
	}
	
	fileprivate func drawAxisConnection(in context: CGContext, bounds: CGRect) {
		context.setFillColor(axisColor.cgColor)
		bounds.fill()
	}
	
	fileprivate func drawDataPoint(in context: CGContext, x: Double, y: Double, bounds: CGRect) {
		
		let point = relativePoint(x: x, y: y, in: bounds)
		
		context.setLineWidth(pointStrokeWidth)
		context.setStrokeColor(pointStrokeColor.cgColor)
		context.setFillColor(pointFillColor.cgColor)
		
		context.addArc(center: point,
									 radius: pointRadius,
									 startAngle: 0,
									 endAngle: 2 * .pi,
									 clockwise: true)
		
		context.fillPath()
		
		context.addArc(center: point,
									 radius: pointRadius,
									 startAngle: 0,
									 endAngle: 2 * .pi,
									 clockwise: true)
		
		context.strokePath()
		
	}
	
	fileprivate func drawConnectionLine(in context: CGContext, bounds: CGRect) {
		
		let relativePoints = dataPoints.map { relativePoint(x: $0.x, y: $0.y, in: bounds) }
		
		guard relativePoints.count > 1 else { return }
		
		context.setStrokeColor(connectionLineColor.cgColor)
		
		let path = CGMutablePath()
		
		path.move(to: relativePoints.first!)
		
		for point in relativePoints.dropFirst() {
			path.addLine(to: point)
		}
		
		context.addPath(path)
		context.strokePath()
	}
	
	required init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
		
		#if TARGET_INTERFACE_BUILDER
		
		dataPoints = [(x: 0.0, y: 0.0),
									(x: 0.9, y: 0.5),
									(x: 1.8, y: 1.0),
									(x: 2.7, y: 0.8),
									(x: 4.8, y: 2.1),
									(x: 5.9, y: 4.6),
									(x: 7.3, y: 6.1),
									(x: 8.1, y: 7.1),
									(x: 9.5, y: 9.0),
									(x: 10.0, y: 10.0)]
		
		axisMinX = 0.0
		axisMaxX = 10.0
		axisMinY = 0.0
		axisMaxY = 10.0
		
		minimumX = 0.0
		maximumX = 10.0
		minimumY = 0.0
		maximumY = 10.0
		
		#endif
	}
}
