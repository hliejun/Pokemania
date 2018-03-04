//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class Renderer {
    private weak var delegate: GameEngineDelegate?
    private let blobSize: CGSize
    private var projectileViews: [Projectile: ProjectileView]
    private var bubbleViews: [Bubble: BubbleCell]
    private var launcherView: LauncherView
    private var bufferView: UIImageView

    init(delegate: GameEngineDelegate?) {
        self.delegate = delegate
        launcherView = LauncherView()
        bufferView = UIImageView()
        projectileViews = [:]
        bubbleViews = [:]
        let diameter: CGFloat = delegate?.getProjectileSize() ?? 0
        blobSize = CGSize(width: diameter, height: diameter)
    }

    func getView(of launcher: Launcher) -> LauncherView {
        return launcherView
    }

    func getView(of projectile: Projectile) -> ProjectileView? {
        return projectileViews[projectile]
    }

    func addView(of bubble: Bubble, at position: Position) {
        let view = BubbleCell()
        let index = IndexPath(item: position.column, section: position.row)
        guard let gridPosition = delegate?.getGridView().cellForItem(at: index)?.center else {
            return
        }
        let center = delegate?.getGridView().convert(gridPosition, to: delegate?.getMainView())
        view.setStyle(sprite: getAsset(for: bubble))
        view.frame = CGRect(origin: CGPoint.zero, size: blobSize)
        view.center = center ?? CGPoint.zero
        if bubbleViews[bubble] != nil {
            removeView(of: bubble)
        }
        bubbleViews[bubble] = view
        updateSubview(view)
    }

    func removeView(of projectile: Projectile) {
        projectileViews[projectile]?.removeFromSuperview()
        projectileViews[projectile] = nil
    }

    func removeView(of bubble: Bubble) {
        bubbleViews[bubble]?.removeFromSuperview()
        bubbleViews[bubble] = nil
    }

    func redraw(_ launcher: Launcher) {
        if launcherView.image != nil {
            if let nextType = launcher.nextInBuffer {
                bufferView.image = assets[nextType]
                launcherView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
            launcherView.transform = CGAffineTransform(rotationAngle: CGFloat(launcher.direction * .pi / 180.0))
        } else if let dockArea = delegate?.getDockArea(), let size = delegate?.getLauncherSize() {
            let launcherRatio = launcherAsset.size.width / launcherAsset.size.height
            launcherView.image = launcherAsset
            launcherView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size * launcherRatio, height: size))
            launcherView.center = CGPoint(x: dockArea.midX, y: dockArea.midY)
            bufferView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size / 3, height: size / 3))
            bufferView.center = launcherView.center.applying(CGAffineTransform(translationX: 0, y: size / 6))
            bufferView.layer.borderWidth = 2
            bufferView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            bufferView.layer.cornerRadius = bufferView.frame.width / 2
        }
        updateSubview(launcherView)
        updateSubview(bufferView)
    }

    func redraw(_ projectile: Projectile) {
        let existingView = projectileViews[projectile]
        let view = existingView ?? ProjectileView()
        let size = existingView?.frame.size ?? blobSize
        if existingView == nil {
            view.setStyle(sprite: getAsset(for: projectile))
            projectileViews[projectile] = view
        }
        view.frame = CGRect(origin: projectile.location, size: size)
        updateSubview(view)
    }

    func animateView(of bubble: Bubble, isCleaning: Bool = false,
                     completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        guard let view = bubbleViews[bubble] else {
            return
        }
        let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.6) {
            view.alpha = 0.0
            view.center = isCleaning ? view.center.applying(CGAffineTransform(translationX: 0, y: 100)) : view.center
        }
        if let handler = completion {
            animator.addCompletion(handler)
        }
        animator.startAnimation()
    }

    private func getAsset(for projectile: Projectile) -> UIImageView? {
        guard let image = assets[projectile.type] else {
            return nil
        }
        return UIImageView(image: image)
    }

    private func getAsset(for bubble: Bubble) -> UIImageView? {
        guard let image = assets[bubble.getType()] else {
            return nil
        }
        return UIImageView(image: image)
    }

    private func updateSubview(_ subview: UIView) {
        guard let source = delegate else {
            return
        }
        subview.removeFromSuperview()
        source.getMainView().addSubview(subview)
    }

}
