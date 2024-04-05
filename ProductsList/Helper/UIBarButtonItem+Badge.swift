//
//  UIBarButtonItem+Badge.swift
//  ProductsList
//
//  Created by Harshit Kumar on 04/04/24.
//

import UIKit

import Foundation

extension UIBarButtonItem {

    convenience init(icon: UIImage, badge: String, _ badgeBackgroundColor: UIColor = #colorLiteral(red: 0.9156965613, green: 0.380413115, blue: 0.2803866267, alpha: 1), target: Any? = UIBarButtonItem.self, action: Selector? = nil) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        imageView.image = icon

        let label = UILabel(frame: CGRect(x: -8, y: -5, width: 18, height: 18))
        label.text = badge
        label.backgroundColor = badgeBackgroundColor
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.clipsToBounds = true
        label.layer.cornerRadius = 18 / 2
        label.textColor = .white

        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        buttonView.addSubview(imageView)
        buttonView.addSubview(label)
        buttonView.addGestureRecognizer(UITapGestureRecognizer.init(target: target, action: action))
        self.init(customView: buttonView)
    }

}


extension CAShapeLayer {
func drawRoundedRect(rect: CGRect, andColor color: UIColor, filled: Bool) {
    fillColor = filled ? color.cgColor : UIColor.white.cgColor
    strokeColor = color.cgColor
    path = UIBezierPath(roundedRect: rect, cornerRadius: 7).cgPath
}
}

private var handle: UInt8 = 0;

extension UIBarButtonItem {
private var badgeLayer: CAShapeLayer? {
    if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
        return b as? CAShapeLayer
    } else {
        return nil
    }
}

func setBadge(text: String?, withOffsetFromTopRight offset: CGPoint = CGPoint.zero, andColor color:UIColor = UIColor.red, andFilled filled: Bool = true, andFontSize fontSize: CGFloat = 11)
{
    badgeLayer?.removeFromSuperlayer()

    if (text == nil || text == "") {
        return
    }

    addBadge(text: text!, withOffset: offset, andColor: color, andFilled: filled)
}

 func addBadge(text: String, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true, andFontSize fontSize: CGFloat = 11)
{
    guard let view = self.value(forKey: "view") as? UIView else { return }

    var font = UIFont.systemFont(ofSize: fontSize)

     if #available(iOS 9.0, *) { font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: UIFont.Weight.regular) }
    let badgeSize = text.size(withAttributes: [NSAttributedString.Key.font: font])

    // Initialize Badge
    let badge = CAShapeLayer()

    let height = badgeSize.height;
    var width = badgeSize.width + 2 /* padding */

    //make sure we have at least a circle
    if (width < height) {
        width = height
    }

    //x position is offset from right-hand side
    let x = view.frame.width - width + offset.x

    let badgeFrame = CGRect(origin: CGPoint(x: x, y: offset.y), size: CGSize(width: width, height: height))

    badge.drawRoundedRect(rect: badgeFrame, andColor: color, filled: filled)
    view.layer.addSublayer(badge)

    // Initialiaze Badge's label
    let label = CATextLayer()
    label.string = text
    label.alignmentMode = CATextLayerAlignmentMode.center
    label.font = font
    label.fontSize = font.pointSize

    label.frame = badgeFrame
    label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
    label.backgroundColor = UIColor.clear.cgColor
    label.contentsScale = UIScreen.main.scale
    badge.addSublayer(label)

    // Save Badge as UIBarButtonItem property
    objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

private func removeBadge() {
    badgeLayer?.removeFromSuperlayer()
}
}
