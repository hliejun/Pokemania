//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

public struct Queue<T> {
    private var queue = [T]()

    public var count: Int {
        return queue.count
    }

    public var isEmpty: Bool {
        return queue.isEmpty
    }

    public mutating func enqueue(_ item: T) {
        queue.append(item)
    }

    public mutating func removeAll() {
        queue.removeAll()
    }

    @discardableResult
    public mutating func dequeue() -> T? {
        return queue.isEmpty ? nil : queue.removeFirst()
    }

    public func peek() -> T? {
        return queue.first
    }

    public func toArray() -> [T] {
        return queue
    }

}
