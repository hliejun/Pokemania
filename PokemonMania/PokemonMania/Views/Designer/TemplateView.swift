//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class TemplateView: UICollectionViewCell {
    var label: UILabel?
    var thumbnail: UIImageView?

    override func layoutSubviews() {
        super.layoutSubviews()
        decorate()
    }

    func setStyle(preview: UIImageView?, title: String) {
        let ratio = (preview?.image?.size.height ?? 1) / (preview?.image?.size.width ?? 1)
        let size = CGSize(width: bounds.width, height: ratio * bounds.width)
        label = label ?? getLabel(text: title)
        thumbnail?.removeFromSuperview()
        thumbnail = preview
        thumbnail?.frame = CGRect(origin: CGPoint.zero, size: size)
        thumbnail?.center.x = bounds.midX
        if let thumbnailView = thumbnail {
            addSubview(thumbnailView)
        }
        if let labelView = label {
            addSubview(labelView)
        }
    }

    private func getLabel(text title: String) -> UILabel {
        let height = CGFloat(40)
        let label = UILabel(frame: CGRect(x: bounds.minX, y: bounds.maxY - height, width: bounds.width, height: height))
        label.center.x = bounds.midX
        label.text = title
        return label
    }

    private func decorate() {
        backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        layer.cornerRadius = 18
        layer.masksToBounds = false
        layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        layer.shadowOffset = CGSize(width: 8, height: 8)
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 12
        decorateLabel()
    }

    private func decorateLabel() {
        guard let labelView = label else {
            return
        }
        labelView.adjustsFontSizeToFitWidth = true
        labelView.backgroundColor = #colorLiteral(red: 0.3752387153, green: 0.3752387153, blue: 0.3752387153, alpha: 0.6481967038)
        labelView.font = UIFont.boldSystemFont(ofSize: 24.0)
        labelView.layer.cornerRadius = 18
        labelView.shadowColor = #colorLiteral(red: 0.3231749468, green: 0.3231749468, blue: 0.3231749468, alpha: 0.6994863014)
        labelView.shadowOffset = CGSize(width: -1.4, height: -1.4)
        labelView.textAlignment = .center
        labelView.textColor = #colorLiteral(red: 0.941156684, green: 0.941156684, blue: 0.941156684, alpha: 1)
        let labelLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: labelView.bounds,
                                byRoundingCorners: [.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 18, height: 18))
        labelLayer.frame = labelView.bounds
        labelLayer.path = path.cgPath
        labelView.layer.mask = labelLayer
    }

}
