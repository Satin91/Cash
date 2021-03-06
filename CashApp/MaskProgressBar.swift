//
//  MaskProgressBar.swift
//  cashApp
//
//  Created by Charadrii on 18.03.21.
//  Copyright © 2021 Charadrii. All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//



import UIKit

public class MaskProgressBar : NSObject {

    //// Cache

    private struct Cache {
        static let color3: UIColor = UIColor(red: 0.188, green: 0.867, blue: 0.850, alpha: 1.000)
        static let color4: UIColor = UIColor(red: 0.754, green: 0.474, blue: 0.959, alpha: 1.000)
        static let gradient: CGGradient = CGGradient(colorsSpace: nil, colors: [MaskProgressBar.color3.cgColor, MaskProgressBar.color3.blended(withFraction: 0.5, of: MaskProgressBar.color4).cgColor, MaskProgressBar.color4.cgColor] as CFArray, locations: [0, 0.52, 1])!
    }

    //// Colors

    @objc dynamic public class var color3: UIColor { return Cache.color3 }
    @objc dynamic public class var color4: UIColor { return Cache.color4 }

    //// Gradients

    @objc dynamic public class var gradient: CGGradient { return Cache.gradient }

    //// Drawing Methods

    @objc dynamic public class func drawProgressBar(frame: CGRect = CGRect(x: 0, y: 14, width: 290, height: 26), progress: CGFloat = 210, xMin: CGFloat = 26, xMax: CGFloat = 290) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!


        //// Variable Declarations
        let progressGrid: CGFloat = progress >= xMin && progress <= xMax ? progress : (progress < xMin ? xMin : xMax)

        //// Color Rectangle Drawing
        let colorRectangleRect = CGRect(x: frame.minX + frame.width - 290, y: frame.minY + frame.height - 26, width: 290, height: 26)
        let colorRectanglePath = UIBezierPath(roundedRect: colorRectangleRect, cornerRadius: 13)
        context.saveGState()
        colorRectanglePath.addClip()
        context.drawLinearGradient(MaskProgressBar.gradient,
            start: CGPoint(x: colorRectangleRect.minX, y: colorRectangleRect.midY),
            end: CGPoint(x: colorRectangleRect.maxX, y: colorRectangleRect.midY),
            options: [])
        context.restoreGState()


        //// ProgressBarActive Drawing
        context.saveGState()
        context.translateBy(x: 3, y: -2)

        context.saveGState()
        context.setBlendMode(.destinationIn)
        context.beginTransparencyLayer(auxiliaryInfo: nil)

        let progressBarActivePath = UIBezierPath(roundedRect: CGRect(x: -3, y: 2, width: progressGrid, height: 26), cornerRadius: 13)
        UIColor.black.setFill()
        progressBarActivePath.fill()
        UIColor.gray.setStroke()
        progressBarActivePath.lineWidth = 0
        progressBarActivePath.stroke()

        context.endTransparencyLayer()
        context.restoreGState()

        context.restoreGState()
    }

    @objc dynamic public class func drawActivityProgressBar(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 290, height: 26), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 290, height: 26), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 290, y: resizedFrame.height / 26)


        //// Color Declarations
        let color8 = UIColor(red: 0.157, green: 0.204, blue: 0.314, alpha: 1.000)

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 290, height: 26), cornerRadius: 13)
        color8.setFill()
        rectanglePath.fill()


        //// Symbol Drawing
        context.saveGState()
        context.setBlendMode(.sourceAtop)
        context.beginTransparencyLayer(auxiliaryInfo: nil)

        let symbolRect = CGRect(x: 0, y: 0, width: 290, height: 26)
        context.saveGState()
        context.clip(to: symbolRect)
        context.translateBy(x: symbolRect.minX, y: symbolRect.minY)

        MaskProgressBar.drawProgressBar(frame: CGRect(x: 0, y: 0, width: symbolRect.width, height: symbolRect.height), progress: 216, xMin: 26, xMax: 290)
        context.restoreGState()

        context.endTransparencyLayer()
        context.restoreGState()
        
        context.restoreGState()

    }




    @objc(MaskProgressBarResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}



private extension UIColor {
    func blended(withFraction fraction: CGFloat, of color: UIColor) -> UIColor {
        var r1: CGFloat = 1, g1: CGFloat = 1, b1: CGFloat = 1, a1: CGFloat = 1
        var r2: CGFloat = 1, g2: CGFloat = 1, b2: CGFloat = 1, a2: CGFloat = 1

        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(red: r1 * (1 - fraction) + r2 * fraction,
            green: g1 * (1 - fraction) + g2 * fraction,
            blue: b1 * (1 - fraction) + b2 * fraction,
            alpha: a1 * (1 - fraction) + a2 * fraction);
    }
}
