//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class GridBubbleView: BubbleView {
    let overlay: UIImageView?

    init(context: CGRect) {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bubble-burst-1"))
        imageView.frame = CGRect(origin: CGPoint.zero, size: context.size)
        imageView.animationImages = bubbleBurstImages
        imageView.animationDuration = Animations.duration.rawValue / 2
        imageView.animationRepeatCount = 1
        self.overlay = imageView
        super.init(frame: context)
        self.overlay?.center = center
        decorate()
        addSubview(imageView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    override func setStyle(sprite: UIImageView?) {
        super.setStyle(sprite: sprite)
        if let animation = overlay {
            bringSubview(toFront: animation)
        }
    }

    func animateBurst(handler: AnimationHandler?) {
        let animator = UIViewPropertyAnimator(duration: Animations.duration.rawValue, dampingRatio: 1) {
            self.alpha = 0
        }
        if let completionHandler = handler {
            animator.addCompletion(completionHandler)
        }
        animator.startAnimation()
        overlay?.startAnimating()
    }

    func animateDrop(handler: AnimationHandler?) {
        let animator = UIViewPropertyAnimator(duration: Animations.duration.rawValue, dampingRatio: 1) {
            let transform = CGAffineTransform(translationX: 0, y: CGFloat(Animations.displacement.rawValue))
            self.alpha = 0
            self.center = self.center.applying(transform)
        }
        if let completionHandler = handler {
            animator.addCompletion(completionHandler)
        }
        animator.startAnimation()
    }

}
