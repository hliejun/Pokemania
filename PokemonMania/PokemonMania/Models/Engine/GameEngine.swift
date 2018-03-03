//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit
import PhysicsEngine

protocol GameEngineDelegate: class {
    func getGameArea() -> CGRect
    func getDockArea() -> CGRect
    func getLauncherSize() -> CGFloat
    func getProjectileSize() -> CGFloat
    func getMainView() -> UIView
    func getGridView() -> UICollectionView
    func updateGrid(at positions: Set<Position>)
}

class GameEngine {
    private weak var viewDelegate: GameEngineDelegate?
    private var physics: PhysicsEngine
    private var renderer: Renderer
    private var stage: Stage
    private var launcher: Launcher
    private var projectiles: Set<Projectile> = Set()

    private lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(stepGameState))
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
        return displayLink
    }()

    var bubbles: [Position: Bubble] {
        return stage.getBubbles()
    }

    var origin: CGPoint {
        let dockArea = viewDelegate?.getDockArea() ?? CGRect.zero
        return CGPoint(x: dockArea.midX, y: dockArea.midY)
    }

    var projectileSize: CGFloat {
        return viewDelegate?.getProjectileSize() ?? 0
    }

    var grid: UICollectionView? {
        return viewDelegate?.getGridView()
    }

    init?(stage: Stage, delegate: GameEngineDelegate?) {
        guard let viewDelegate = delegate, let launcher = Launcher(using: options) else {
            return nil
        }
        self.viewDelegate = viewDelegate
        self.stage = stage
        self.launcher = launcher
        physics = PhysicsEngine(bounds: viewDelegate.getGameArea())
        renderer = Renderer(delegate: viewDelegate)
        setupLauncherGestures(on: viewDelegate.getMainView())
        displayLink.isPaused = false
    }

    func launchBubble() {
        if let projectile = launcher.launch(from: origin, diameter: projectileSize, using: physics) {
            projectiles.insert(projectile)
        }
    }

    private func addBubble(type: Type, at nearestSlot: Position) {
        stage.insertBubble(type: type, at: nearestSlot)
        viewDelegate?.updateGrid(at: [nearestSlot])
        if let bubble = bubbles[nearestSlot] {
            findAndScoreMatches(of: bubble, minimumCount: 3)
        }
    }

    private func removeBubble(_ bubble: Bubble, matched: Bool = true) {
        stage.removeBubble(bubble)
        renderer.animateView(of: bubble, shouldFlash: !matched) { _ in
            self.viewDelegate?.updateGrid(at: [bubble.getPosition()])
        }
        if matched {
            findAndRemoveDisconnectedBubbles()
        }
    }

    private func updateScore(with bubbles: Set<Bubble>) {
        stage.updateScore(increment: 10)
    }

    private func setLauncher(pointAt location: CGPoint, strength: Double = fixedStrength) {
        let angle = physics.getAngle(of: location, from: origin)
        launcher.direction = angle
        launcher.strength = strength
    }

    private func updateState(of projectile: Projectile) {
        let points = physics.getPoints(from: projectile.collider).map { point in return getPointInGrid(at: point) }
        if physics.willCollide(projectile, with: getObstacles(near: points)) {
            if let index = getNearestSlot(to: projectile, using: points) {
                addBubble(type: projectile.type, at: Position(row: index.section, column: index.item))
            }
            renderer.removeView(of: projectile)
            projectiles.remove(projectile)
            return
        } else if let wall = physics.willDeflectWithWall(projectile) {
            physics.deflect(projectile, against: wall)
        }
        physics.move(projectile)
        renderer.redraw(projectile)
    }

    private func findAndScoreMatches(of bubble: Bubble, minimumCount: Int) {
        let matchedBubbles = getBubblesConnected(to: Set([bubble]), with: bubble.getEnergy())
        if matchedBubbles.count >= minimumCount {
            matchedBubbles.forEach { matched in removeBubble(matched) }
            updateScore(with: matchedBubbles)
        }
    }

    private func findAndRemoveDisconnectedBubbles() {
        var rootBubbles = bubbles.filter { position, _ in return position.row == 0 }
        Set(bubbles.values).subtracting(getBubblesConnected(to: Set(rootBubbles.values)))
            .forEach { bubble in removeBubble(bubble, matched: false) }
    }

    private func getBubblesConnected(to initialBubbles: Set<Bubble>, with energy: Type.Energy? = nil) -> Set<Bubble> {
        var neighbours = Queue<Bubble>()
        var connectedBubbles = Set<Bubble>()
        initialBubbles.forEach { bubble in neighbours.enqueue(bubble) }
        while let currentBubble = neighbours.dequeue() {
            if let energyType = energy {
                if !connectedBubbles.contains(currentBubble) && currentBubble.getEnergy() == energyType {
                    connectedBubbles.insert(currentBubble)
                    getNeighbours(of: currentBubble).forEach { neighbour in neighbours.enqueue(neighbour) }
                }
            } else if !connectedBubbles.contains(currentBubble) {
                connectedBubbles.insert(currentBubble)
                getNeighbours(of: currentBubble).forEach { neighbour in neighbours.enqueue(neighbour) }
            }
        }
        return connectedBubbles
    }

    private func getNeighbours(of target: Bubble) -> Set<Bubble> {
        let location = target.getPosition()
        let neighbours = bubbles.filter { position, _ in
            let rowGap = location.row - position.row
            let columnGap = location.column - position.column
            if rowGap.magnitude == 1 {
                return location.row % 2 == 0 ? columnGap == 0 || columnGap == 1 : columnGap == 0 || columnGap == -1
            } else if rowGap.magnitude == 0 {
                return columnGap.magnitude == 1
            }
            return false
        }
        return Set(neighbours.values)
    }

    private func setupLauncherGestures(on delegatedView: UIView?) {
        delegatedView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDelegate)))
        delegatedView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanDelegate)))
    }

    private func getObstacles(near points: [CGPoint]) -> [CGRect] {
        return points.reduce(into: [CGRect]()) { list, point in
            guard let source = grid, let indexPath = source.indexPathForItem(at: point) else {
                return
            }
            let position = Position(row: indexPath.section, column: indexPath.item)
            if let collider = source.cellForItem(at: indexPath)?.frame, bubbles[position] != nil {
                list.append(source.convert(collider, to: viewDelegate?.getMainView()))
            }
        }
    }

    private func getNearestSlot(to projectile: Projectile, using coordinates: [CGPoint]) -> IndexPath? {
        var index: IndexPath? = nil
        var smallestDistance = CGFloat.greatestFiniteMagnitude
        let center = getPointInGrid(at: physics.getCenter(from: projectile.collider))
        coordinates.forEach { location in
            guard let indexPath = grid?.indexPathForItem(at: location),
                  let point = grid?.cellForItem(at: indexPath)?.center else {
                return
            }
            let position = Position(row: indexPath.section, column: indexPath.item)
            let distance = physics.getDistance(between: center, and: point)
            if bubbles[position] == nil && distance < smallestDistance {
                smallestDistance = distance
                index = indexPath
            }
        }
        return index
    }

    private func getPointInGrid(at coordinate: CGPoint) -> CGPoint {
        return viewDelegate?.getMainView().convert(coordinate, to: grid) ?? CGPoint.zero
    }

    @objc
    func stepGameState() {
        renderer.redraw(launcher)
        projectiles.forEach { projectile in updateState(of: projectile) }
    }

    @objc
    func didTapDelegate(_ recognizer: UITapGestureRecognizer) {
        setLauncher(pointAt: recognizer.location(in: recognizer.view))
        launchBubble()
    }

    @objc
    func didPanDelegate(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            launcher.isAssistEnabled = true
        case .changed:
            setLauncher(pointAt: recognizer.location(in: recognizer.view))
        case .ended:
            launchBubble()
            launcher.isAssistEnabled = false
        default:
            return
        }
    }

}
