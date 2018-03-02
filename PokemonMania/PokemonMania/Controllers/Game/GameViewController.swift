//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit
import Foundation

class GameViewController: UIViewController, GameEngineDelegate, GameGridDelegate {
    @IBOutlet private var dock: UIView!
    private var gridControl: GameGridController?
    private var gameEngine: GameEngine?
    private var loadedStage = Stage()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let seguedController = segue.destination
        if let controller = seguedController as? GameGridController {
            gridControl = controller
            gridControl?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDemoStage()
    }

    override func viewDidLayoutSubviews() {
        gameEngine = gameEngine ?? GameEngine(stage: loadedStage, delegate: self)
        gridControl?.bubbles = gameEngine?.bubbles
        gridControl?.reloadVisibleItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getGameArea() -> CGRect {
        return view.frame
    }

    func getDockArea() -> CGRect {
        return dock.frame
    }

    func getLauncherSize() -> CGFloat {
        return dock.frame.height
    }

    func getProjectileSize() -> CGFloat {
        return gridControl?.cellSize ?? 0
    }

    func getMainView() -> UIView {
        return view
    }

    func getGridView() -> UICollectionView {
        guard let grid = gridControl?.collectionView else {
            fatalError("Fatal: No grid provided for game engine.")
        }
        return grid
    }

    func updateGrid(at positions: Set<Position>) {
        let indices = positions.reduce(into: []) { list, position in
            list.append(IndexPath(item: position.column, section: position.row))
        }
        UIView.performWithoutAnimation {
            gridControl?.bubbles = gameEngine?.bubbles
            gridControl?.collectionView?.reloadItems(at: indices)
        }
    }

    private func setupDemoStage() {
        sampleBubbles.forEach { bubble in loadedStage.insertBubble(bubble) }
    }

}
