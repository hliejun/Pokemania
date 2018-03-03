//  Created by Huang Lie Jun on 3/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import PhysicsEngine

extension PhysicsEngine {

    func getPoints(from collider: CGRect) -> [CGPoint] {
        var contactPoints: [CGPoint] = []
        let orthogonalCollider = collider.applying(CGAffineTransform(rotationAngle: .pi / 4))
        contactPoints += getEdges(from: collider) + getEdges(from: orthogonalCollider)
        contactPoints.append(getCenter(from: collider))
        return contactPoints
    }

    func getEdges(from collider: CGRect) -> [CGPoint] {
        return [
            CGPoint(x: collider.minX, y: collider.minY),
            CGPoint(x: collider.minX, y: collider.maxY),
            CGPoint(x: collider.maxX, y: collider.minY),
            CGPoint(x: collider.maxX, y: collider.maxY)
        ]
    }

    func getCenter(from collider: CGRect) -> CGPoint {
        return CGPoint(x: collider.midX, y: collider.midY)
    }

    func getDistance(between pointA: CGPoint, and pointB: CGPoint) -> CGFloat {
        return hypot(pointA.x - pointB.x, pointA.y - pointB.y)
    }

}
