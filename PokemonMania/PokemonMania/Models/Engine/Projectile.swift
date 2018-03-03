//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit
import PhysicsEngine

class Projectile: PhysicsObject {
    let type: Type

    init(identifier: String, type: Type, at location: CGPoint, diameter: CGFloat) {
        self.type = type
        super.init(identifier: identifier, at: location, diameter: diameter)
    }

    static func == (lhs: Projectile, rhs: Projectile) -> Bool {
        let superLeft: PhysicsObject = lhs
        let superRight: PhysicsObject = rhs
        return lhs.type == rhs.type && superLeft == superRight
    }

}
