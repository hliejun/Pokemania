//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class TemplateCell: UICollectionViewCell {
    var label: UILabel?
    var thumbnail: UIImageView?

    override func layoutSubviews() {
        super.layoutSubviews()
        decorate()
    }

    func setStyle(preview: UIImageView?, title: String) {
        thumbnail?.removeFromSuperview()
        thumbnail = preview
        let ratio = (thumbnail?.image?.size.height ?? 1) / (thumbnail?.image?.size.width ?? 1)
        thumbnail?.frame = CGRect(x: 0, y: 0, width: bounds.width, height: ratio * bounds.width)
        thumbnail?.center.x = bounds.midX
        label = label == nil ? addStyledLabel() : label
        label?.text = title
        if let imageView = thumbnail {
            addSubview(imageView)
        }
        if let labelView = label {
            bringSubview(toFront: labelView)
        }
    }

    private func decorate() {
        backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        layer.cornerRadius = 18
        layer.shadowRadius = 12
        layer.shadowOffset = CGSize(width: 8, height: 8)
        layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        layer.shadowOpacity = 0.6
        layer.masksToBounds = false
    }

    private func addStyledLabel() -> UILabel {
        let height = CGFloat(40)
        let label = UILabel(frame: CGRect(x: bounds.minX, y: bounds.maxY - height, width: bounds.width, height: height))
        label.center.x = bounds.midX
        label.textColor = #colorLiteral(red: 0.941156684, green: 0.941156684, blue: 0.941156684, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = #colorLiteral(red: 0.3752387153, green: 0.3752387153, blue: 0.3752387153, alpha: 0.6481967038)
        label.shadowColor = #colorLiteral(red: 0.3231749468, green: 0.3231749468, blue: 0.3231749468, alpha: 0.6994863014)
        label.shadowOffset = CGSize(width: -1.4, height: -1.4)
        label.layer.cornerRadius = 18
        let path = UIBezierPath(roundedRect: label.bounds,
                                byRoundingCorners: [.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 18, height: 18))
        let layer = CAShapeLayer()
        layer.frame = label.bounds
        layer.path = path.cgPath
        label.layer.mask = layer
        addSubview(label)
        return label
    }

}
