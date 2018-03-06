//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class LauncherView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        decorate()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    func decorate() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }

}
