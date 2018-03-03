//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit
import Foundation

protocol GameGridDelegate: class {
    func setup()
}

class GameGridController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet private var grid: UICollectionView!
    weak var delegate: GameGridDelegate?
    var cellSize: CGFloat = 0
    var maxRows: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGrid()
    }

    override func viewDidLayoutSubviews() {
        delegate?.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return maxRows
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return section % 2 == 0 ? maxColumns : maxColumns - 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BubbleCell", for: indexPath)
        guard let bubbleCell = cell as? BubbleCell else {
            fatalError("Fatal: BubbleCell cannot be used.")
        }
        bubbleCell.setStyle(sprite: nil)
        return bubbleCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = collectionView.bounds.width / CGFloat(maxColumns * 2 + 1)
        let padding = -inset / 5
        return section % 2 == 0
            ? UIEdgeInsets(top: 0, left: 0, bottom: padding, right: 0)
            : UIEdgeInsets(top: 0, left: inset, bottom: padding, right: inset)
    }

    func reloadVisibleItems() {
        grid.reloadItems(at: grid.indexPathsForVisibleItems)
        grid.layoutIfNeeded()
    }

    private func setupGrid() {
        cellSize = grid.frame.width / CGFloat(maxColumns)
        maxRows = Int(grid.frame.height / cellSize) - 1
    }

}
