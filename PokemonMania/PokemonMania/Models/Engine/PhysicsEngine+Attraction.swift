//  Created by Huang Lie Jun on 7/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import PhysicsEngine

extension PhysicsEngine {

    func move(_ object: PhysicsObject, magnetPoints: [CGPoint]) {
        let center = CGPoint(x: object.collider.midX, y: object.collider.midY)
        var horizontalComponent: CGFloat = 0, verticalComponent: CGFloat = 0
        if let velocity = object.getLinearVelocity() {
            horizontalComponent = CGFloat(velocity.xValue)
            verticalComponent = CGFloat(velocity.yValue)
        }
        magnetPoints.forEach { point in
            let distance = getDistance(between: center, and: point) * pow(10, -2)
            let coefficient = Physics.attraction.rawValue * pow(distance, -2)
            let verticalFactor = center.y - point.y >= 0 ? coefficient : -coefficient
            let horizontalFactor = center.x - point.x <= 0 ? coefficient : -coefficient
            horizontalComponent += horizontalFactor * sqrt(2)
            verticalComponent += verticalFactor * sqrt(2)
        }
        let sumVelocity = Vector(xValue: Double(horizontalComponent), yValue: Double(verticalComponent))
        object.setMovement(velocity: sumVelocity)
        if let velocity = object.getLinearVelocity() {
            object.location = CGPoint(x: object.location.x + CGFloat(velocity.xValue),
                                      y: object.location.y - CGFloat(velocity.yValue))
        }
    }

}
