//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit
import PhysicsEngine

class Launcher {
    // TUTOR: [-1] Variables should be private.
    // Also, buffer is not a very good name for buffer size, right?
    let buffer: Int
    var isAssistEnabled = true
    var strength: Double = LaunchSettings.strength.rawValue
    var direction: Double = 0
    private var launchCount: Int = 0
    private var queue: Queue<Type>
    private var options: Set<Type>

    var nextInBuffer: Type? {
        return queue.peek()
    }

    init?(using options: Set<Type>, buffer: Int = 1) {
        guard !options.isEmpty else {
            return nil
        }
        self.options = options
        self.buffer = buffer
        queue = Queue()
        populateQueue()
    }

    func launch(from origin: CGPoint, diameter: CGFloat, using engine: PhysicsEngine) -> Projectile? {
        let leftLimit = Quadrant.third.rawValue + LaunchSettings.angleLimit.rawValue
        let rightLimit = Quadrant.first.rawValue - LaunchSettings.angleLimit.rawValue
        guard direction > leftLimit || direction < rightLimit, let payloadType = queue.dequeue() else {
            return nil
        }
        populateQueue()
        launchCount += 1
        let velocity = engine.getVelocity(in: direction, using: strength)
        let projectile = Projectile(identifier: "L-\(launchCount)", type: payloadType, at: origin, diameter: diameter)
        projectile.setMovement(velocity: velocity)
        return projectile
    }

    private func populateQueue(withReset: Bool = false) {
        if withReset {
            queue.removeAll()
        }
        while queue.count < buffer {
            queue.enqueue(getRandomType())
        }
    }

    private func getRandomType() -> Type {
        let randomOffset = Int(arc4random_uniform(UInt32(options.count)))
        let randomIndex = options.index(options.startIndex, offsetBy: randomOffset)
        return options[randomIndex]
    }

}
