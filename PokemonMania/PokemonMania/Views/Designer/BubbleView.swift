//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class BubbleView: UICollectionViewCell {
    private var presetColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)

    override func layoutSubviews() {
        super.layoutSubviews()
        decorate()
    }

    func setStyle(sprite: UIImageView?, backgroundColor: UIColor? = nil) {
        sprite?.frame = CGRect(origin: CGPoint.zero, size: bounds.size)
        backgroundView = sprite
        if let color = backgroundColor {
            self.presetColor = color
        }
    }

    func decorate() {
        backgroundColor = presetColor
        layer.cornerRadius = self.frame.height / CGFloat(2)
    }

}
