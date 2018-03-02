//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

class Bubble: Codable {
    private var position: Position
    private var type: Type
    private var energy: Type.Energy

    private enum CodingKeys: String, CodingKey {
        case position, type, energy
    }

    enum CodingError: Error {
        case decoding(String)
    }

    var row: Int {
        return position.row
    }

    var column: Int {
        return position.column
    }

    init(at position: Position, type: Type? = nil, energy: Type.Energy = .none) {
        self.position = position
        self.type = type ?? .energyType(energy)
        self.energy = energy
    }

    func getPosition() -> Position {
        return position
    }

    func setPosition(row: Int, column: Int) {
        position = Position(row: row, column: column)
    }

    func getType() -> Type {
        return type
    }

    func getEnergy() -> Type.Energy {
        return energy
    }

    func changeEnergy(to newEnergy: Type.Energy) {
        energy = newEnergy
    }

    static func == (lhs: Bubble, rhs: Bubble) -> Bool {
        return lhs.position == rhs.position && lhs.type == rhs.type && lhs.energy == rhs.energy
    }

}

extension Bubble: Hashable {

    var hashValue: Int {
        return position.hashValue
    }

}
