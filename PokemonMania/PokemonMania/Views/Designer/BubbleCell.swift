//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class BubbleCell: UICollectionViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        decorate()
    }

    func setStyle(sprite: UIImageView?) {
        sprite?.frame = CGRect(origin: CGPoint.zero, size: bounds.size)
        backgroundView = sprite
    }

    func decorate() {
        layer.cornerRadius = self.frame.height / CGFloat(2)
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.4955318921)
    }

}
