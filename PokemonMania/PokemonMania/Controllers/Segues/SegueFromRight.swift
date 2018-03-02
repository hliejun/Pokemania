//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class SegueFromRight: UIStoryboardSegue {

    override func perform() {
        let source = self.source
        let destination = self.destination
        guard let thisView = source.view, let nextView = destination.view else {
            return
        }
        thisView.superview?.insertSubview(nextView, aboveSubview: thisView)
        nextView.transform = CGAffineTransform(translationX: thisView.frame.size.width, y: 0)
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { nextView.transform = CGAffineTransform(translationX: 0, y: 0) },
                       completion: { _ in source.present(destination, animated: false, completion: nil) })
    }

}
