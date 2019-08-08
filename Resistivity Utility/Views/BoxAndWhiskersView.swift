//
//  BoxAndWhiskersView.swift
//  Resistivity Utility
//
//  Created by Connor Barnes on 7/24/19.
//  Copyright © 2019 Connor Barnes. All rights reserved.
//

import Cocoa

@IBDesignable
class BoxAndWhiskersView: NSView {
	enum Orientation {
		case vertical
		case horizontal
	}
	
	var orientation: Orientation
	
	var min: Double?
	var max: Double?
	var median: Double?
	var lowerQuartile: Double?
	var upperQuartile: Double?
	
	var axisMin: Double?
	var axisMax: Double?
	
	var tickCount: Int?
	
	@IBInspectable var axisWidth: CGFloat = 18
	@IBInspectable var axisSpacing: CGFloat = 12
	
	var relativeMin: CGFloat {
		return relativeFrom(absolute: min!)
	}
	
	var relativeMax: CGFloat {
		return relativeFrom(absolute: max!)
	}
	
	var relativeMedian: CGFloat {
		return relativeFrom(absolute: median!)
	}
	
	var relativeLowerQuartile: CGFloat {
		return relativeFrom(absolute: lowerQuartile!)
	}
	
	var relativeUpperQuartile: CGFloat {
		return relativeFrom(absolute: upperQuartile!)
	}
	
	var relativeAxisMin: CGFloat {
		return relativeFrom(absolute: axisMin!)
	}
	
	var relativeAxisMax: CGFloat {
		return relativeFrom(absolute: axisMax!)
	}
	
	func relativeFrom(absolute value: Double) -> CGFloat {
		return CGFloat((value - axisMin!) / (axisMax! - axisMin!))
	}
	
	@IBInspectable var strokeWidth: CGFloat = 3.0
	
	// MARK: Initializers
	
	override init(frame frameRect: NSRect) {
//		if frameRect.width > frameRect.height {
//			orientation = .horizontal
//		} else {
//			orientation = .vertical
//		}
		
		orientation = .vertical
		
		super.init(frame: frameRect)
	}
	
	required init?(coder decoder: NSCoder) {
		orientation = .vertical
		
		super.init(coder: decoder)
		
		#if TARGET_INTERFACE_BUILDER
		
		min = 13
		max = 84
		median = 47
		lowerQuartile = 21
		upperQuartile = 72
		axisMin = 0.0
		axisMax = 200.0
		tickCount = 11
		
		#endif
		
//		if bounds.width > bounds.height {
//			orientation = .horizontal
//		} else {
//			orientation = .vertical
//		}
	}
	
	// MARK: Drawing
	
	override func draw(_ dirtyRect: NSRect) {
		guard let context = NSGraphicsContext.current?.cgContext else { return }
		
		guard min != nil, max != nil, median != nil, lowerQuartile != nil, upperQuartile != nil, axisMin != nil, axisMax != nil, tickCount != nil else { return }
		
		// Horizontally oriented with origin at 0,0
		var adjustedBounds = CGRect()
		
		switch orientation {
		case .horizontal:
			// Translate
			context.translateBy(x: -bounds.origin.x, y: -bounds.origin.y)
			
			adjustedBounds.origin = .zero
			adjustedBounds.size = bounds.size
		case .vertical:
			// Horizontal Flip
			context.scaleBy(x: -1.0, y: 1.0)
			// Translate
			//			context.translateBy(x: bounds.size.width, y: 0)
			// Rotate
			context.rotate(by: CGFloat.pi / 2)
			// Translate
			context.translateBy(x: -bounds.origin.x, y: -bounds.origin.y)
			
			adjustedBounds.origin = .zero
			adjustedBounds.size.width = bounds.height
			adjustedBounds.size.height = bounds.width
		}
		
		var axisBounds = adjustedBounds
		axisBounds.origin.x = strokeWidth / 2.0
		axisBounds.origin.y = strokeWidth / 2.0
		axisBounds.size.width -= strokeWidth
		axisBounds.size.height = axisWidth - strokeWidth
		
		var plotBounds = adjustedBounds
		plotBounds.origin.x = strokeWidth / 2.0 + (relativeMin - relativeAxisMin)
		plotBounds.origin.y = strokeWidth / 2.0 + axisBounds.size.height + axisSpacing
		plotBounds.size.height -= strokeWidth + axisBounds.size.height + axisSpacing
		plotBounds.size.width -= strokeWidth
		
		
		
		plotBounds.size.width -= relativeAxisMax - relativeMax
		plotBounds.size.width -= relativeMin - relativeAxisMin
		
		context.setStrokeColor(NSColor.textColor.cgColor)
		context.setLineWidth(strokeWidth)
		
		drawWhisker(in: context, bounds: plotBounds)
		drawTicks(in: context, bounds: plotBounds)
		drawBox(in: context, bounds: plotBounds)
		drawMedian(in: context, bounds: plotBounds)
		
		drawAxis(in: context, bounds: axisBounds)
		drawAxisTicks(in: context, bounds: axisBounds)
	}
	
	func drawWhisker(in context: CGContext, bounds: CGRect) {
		let start = CGPoint(x: relativeMin * bounds.width + bounds.minX,
												y: bounds.midY)
		let end = CGPoint(x: relativeMax * bounds.width + bounds.minX,
											y: bounds.midY)
		context.strokeLineSegments(between: [start, end])
	}
	
	func drawTicks(in context: CGContext, bounds: CGRect) {
		
		let bottomY = bounds.midY - bounds.height / 8.0
		let topY = bounds.midY + bounds.height / 8.0
		let leftX = relativeMin * bounds.width + bounds.minX
		let rightX = relativeMax * bounds.width + bounds.minX
		
		let leftTickPoints = [CGPoint(x: leftX,
																	y: bottomY),
													CGPoint(x: leftX,
																	y: topY)]
		
		context.strokeLineSegments(between: leftTickPoints)
		
		let rightTickPoints = [CGPoint(x: rightX,
																	 y: bottomY),
													 CGPoint(x: rightX,
																	 y: topY)]
		
		context.strokeLineSegments(between: rightTickPoints)
	}
	
	func drawBox(in context: CGContext, bounds: CGRect) {
		let bottomY = bounds.minY
		let topY = bounds.maxY
		let leftX = relativeLowerQuartile * bounds.width + bounds.origin.x
		let rightX = relativeUpperQuartile * bounds.width + bounds.origin.x
		
		let rect = CGRect(x: leftX, y: bottomY, width: rightX - leftX, height: topY - bottomY)
		
		context.setFillColor(NSColor.textBackgroundColor.cgColor)
		
		context.fill(rect)
		context.stroke(rect)
	}
	
	func drawMedian(in context: CGContext, bounds: CGRect) {
		let x = relativeMedian * bounds.width + bounds.minX
		let bottomY = bounds.minY
		let topY = bounds.maxY
		
		let points = [CGPoint(x: x, y: bottomY),
									CGPoint(x: x, y: topY)]
		
		context.strokeLineSegments(between: points)
	}
	
	func drawAxis(in context: CGContext, bounds: CGRect) {
		let start = CGPoint(x: bounds.minX,
												y: bounds.midY)
		let end = CGPoint(x: bounds.maxX,
											y: bounds.midY)
		context.strokeLineSegments(between: [start, end])
	}
	
	func drawAxisTicks(in context: CGContext, bounds: CGRect) {
		guard tickCount! > 1 else { return }
		let tickSpacing = bounds.width / CGFloat(tickCount! - 1)
		
		// Stroke first & last ticks
		
		let leftPoints = [CGPoint(x: bounds.minX, y: bounds.minY),
											CGPoint(x: bounds.minX, y: bounds.maxY)]
		
		let rightPoints = [CGPoint(x: bounds.maxX, y: bounds.minY),
											 CGPoint(x: bounds.maxX, y: bounds.maxY)]
		
		context.strokeLineSegments(between: leftPoints)
		context.strokeLineSegments(between: rightPoints)
		// Stroke center ticks
		
		context.setLineWidth(strokeWidth / 2.0)
		
		for x in stride(from: bounds.minX + tickSpacing, to: bounds.maxX, by: tickSpacing) {
			let points = [CGPoint(x: x, y: bounds.minY),
										CGPoint(x: x, y: bounds.maxY)]
			
			context.strokeLineSegments(between: points)
		}
	}
	
	// MARK: Interface Builder
	
	@IBInspectable var isVertical: Bool = true {
		didSet {
			if isVertical {
				orientation = .vertical
			} else {
				orientation = .horizontal
			}
		}
	}
}
