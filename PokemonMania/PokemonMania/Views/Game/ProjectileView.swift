//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class ProjectileView: GridBubbleView {

    override init(context: CGRect) {
        super.init(context: context)
        overlay?.frame = CGRect(origin: CGPoint.zero, size: context.size)

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
