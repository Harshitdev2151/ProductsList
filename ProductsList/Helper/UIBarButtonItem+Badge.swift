//
//  UIBarButtonItem+Badge.swift
//  ProductsList
//
//  Created by Harshit Kumar on 04/04/24.
//

import UIKit
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
