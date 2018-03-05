//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class Renderer {
    private weak var delegate: GameEngineDelegate?
    private let blobSize: CGSize
    private var projectileViews: [Projectile: ProjectileView]
    private var bubbleViews: [Bubble: BubbleCell]
    private var launcherView: LauncherView
    private var launcherStandView: UIImageView
    private var bufferView: UIImageView
    private var hasSetupLauncherSet = false

    init(delegate: GameEngineDelegate?) {
        self.delegate = delegate
        launcherView = LauncherView()
        bufferView = UIImageView()
        launcherStandView = UIImageView()
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
        if hasSetupLauncherSet {
            if let nextType = launcher.nextInBuffer {
                bufferView.image = assets[nextType]
            }
            launcherView.transform = CGAffineTransform(rotationAngle: CGFloat(launcher.direction * .pi / 180.0))
        } else if let dockArea = delegate?.getDockArea(), let size = delegate?.getLauncherSize() {
            setupLauncher(ofSize: size, at: dockArea)
            setupLauncherBase(at: dockArea)
            setupBuffer(ofSize: size)
            hasSetupLauncherSet = true
        }
        updateSubview(bufferView)
        updateSubview(launcherView)
        updateSubview(launcherStandView)
        launcherStandView.superview?.bringSubview(toFront: launcherStandView)
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
        launcherView.superview?.bringSubview(toFront: launcherView)
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

    func animateView(of launcher: Launcher) {
        launcherView.stopAnimating()
        launcherView.startAnimating()
    }

    private func setupLauncher(ofSize size: CGFloat, at dockArea: CGRect) {
        let launcherRatio = launcherImage.size.width / launcherImage.size.height
        launcherView.image = launcherImage
        launcherView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size * launcherRatio, height: size))
        launcherView.center = CGPoint(x: dockArea.midX, y: dockArea.midY)
        launcherView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        launcherView.animationImages = launcherAnimationSet
        launcherView.animationDuration = 0.3
        launcherView.animationRepeatCount = 1
    }

    private func setupLauncherBase(at dockArea: CGRect) {
        let baseRatio = launcherStandImage.size.height / launcherImage.size.width
        let width = launcherView.frame.width
        launcherStandView.image = launcherStandImage
        launcherStandView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: width * baseRatio))
        launcherStandView.center = CGPoint(x: dockArea.midX, y: dockArea.midY)
        launcherStandView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        launcherStandView.layer.zPosition = 100
    }

    private func setupBuffer(ofSize size: CGFloat) {
        bufferView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size / 4, height: size / 4))
        bufferView.center = launcherView.center
        bufferView.layer.cornerRadius = bufferView.frame.width / 2
        bufferView.layer.zPosition = 100
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
