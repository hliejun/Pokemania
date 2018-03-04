//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

let thresholdLaunchRate = 0.15
let maxColumns = 12
let fixedStrength: Double = 0.02
let leftAngleLimit: Double = 280
let rightAngleLimit: Double = 80
let safeMargin: CGFloat = 5

let energyOfType: [Type: Type.Energy] = [
    .energyType(.fire): .fire,
    .energyType(.water): .water,
    .energyType(.grass): .grass,
    .energyType(.electric): .electric
]

let assets: [Type: UIImage] = [
    .energyType(.fire): #imageLiteral(resourceName: "bubble-red"),
    .energyType(.water): #imageLiteral(resourceName: "bubble-blue"),
    .energyType(.grass): #imageLiteral(resourceName: "bubble-green"),
    .energyType(.electric): #imageLiteral(resourceName: "bubble-orange")
]

let launcherAsset = #imageLiteral(resourceName: "cannon")

let effects: [Type.Effect: Effect] = [
    .sunny: Effect(type: .sunny,
                   targets: Set([.fire, .grass]),
                   radius: 0,
                   multiplier: 2.0,
                   energy: .fire)
]

let obstacles: [Type.Obstacle: Obstacle] = [
    .steel: Obstacle(type: .steel,
                     weaknesses: Set([.ice, .fire]),
                     tolerance: 3)
]

let creatures: [Type.Creature: Creature] = [
    .pikachu: Creature(type: .pikachu,
                       energy: .electric,
                       rarity: 0.2,
                       isShiny: true)
]

let options = Set<Type>([
    .energyType(.fire),
    .energyType(.water),
    .energyType(.grass),
    .energyType(.electric)
])

let sampleBubbles = [
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
