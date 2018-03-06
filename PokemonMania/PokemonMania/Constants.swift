//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

enum Formats: String {
    case date = "dd/MM/YY HH:mm"
}

enum GameSettings: Int {
    case baseScore = 10
}

enum DisplaySettings: Int {
    case maxColumns = 12
    case maxRows = 14
}

enum Depth: CGFloat {
    case back = 100
    case middle = 200
    case front = 300
}

enum Style: CGFloat {
    case bufferRatio = 0.25
    case paddingToInsetRatio = 0.2
    case largeMargin = 24
    case largeInset = 20
}

enum Animations: Double {
    case displacement = 100
    case duration = 0.6
}

enum LaunchSettings: Double {
    case angleLimit = 10
    case rate = 0.15
    case strength = 0.02
}

enum Quadrant: Double {
    case first = 90
    case second = 180
    case third = 270
    case fourth = 0
}

let launcherOptions = Set<Type>([
    .energyType(.fire),
    .energyType(.water),
    .energyType(.grass),
    .energyType(.electric)
    ])

let launcherStandImage = #imageLiteral(resourceName: "cannon-base")

let launcherImage = #imageLiteral(resourceName: "cannon-0")

let launcherImages = [#imageLiteral(resourceName: "cannon-1"), #imageLiteral(resourceName: "cannon-2"), #imageLiteral(resourceName: "cannon-3"), #imageLiteral(resourceName: "cannon-4"), #imageLiteral(resourceName: "cannon-5"), #imageLiteral(resourceName: "cannon-6"), #imageLiteral(resourceName: "cannon-7"), #imageLiteral(resourceName: "cannon-8"), #imageLiteral(resourceName: "cannon-9"), #imageLiteral(resourceName: "cannon-10"), #imageLiteral(resourceName: "cannon-11"), #imageLiteral(resourceName: "cannon-0")]

let bubbleImages: [Type: UIImage] = [
    .energyType(.fire): #imageLiteral(resourceName: "bubble-red"),
    .energyType(.water): #imageLiteral(resourceName: "bubble-blue"),
    .energyType(.grass): #imageLiteral(resourceName: "bubble-green"),
    .energyType(.electric): #imageLiteral(resourceName: "bubble-orange")
]

let globalEffects: [Type.Effect: Effect] = [
    .sunny: Effect(type: .sunny, targets: Set([.fire, .grass]), radius: 0, multiplier: 2.0, energy: .fire)
]

let globalObstacles: [Type.Obstacle: Obstacle] = [
    .steel: Obstacle(type: .steel, weaknesses: Set([.ice, .fire]), tolerance: 3)
]

let globalCreatures: [Type.Creature: Creature] = [
    .pikachu: Creature(type: .pikachu, energy: .electric, rarity: 0.2, isShiny: true)
]

let globalTemplateBubbles = [
    Bubble(at: Position(row: 0, column: 4), energy: .electric),
    Bubble(at: Position(row: 0, column: 5), energy: .water),
    Bubble(at: Position(row: 0, column: 6), energy: .grass),
    Bubble(at: Position(row: 0, column: 7), energy: .fire),
    Bubble(at: Position(row: 1, column: 4), energy: .electric),
    Bubble(at: Position(row: 1, column: 5), energy: .water),
    Bubble(at: Position(row: 1, column: 6), energy: .grass),
    Bubble(at: Position(row: 2, column: 5), energy: .fire),
    Bubble(at: Position(row: 2, column: 6), energy: .fire)
]
