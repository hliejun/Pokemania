//  Created by Huang Lie Jun on 6/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class BufferView: UIImageView {

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
        layer.cornerRadius = frame.width / 2
        layer.zPosition = Depth.back.rawValue
    }

}
