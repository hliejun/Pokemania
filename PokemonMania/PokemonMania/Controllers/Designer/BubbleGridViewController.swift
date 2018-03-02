//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

protocol DesignDelegate: class {
    func didSelect(position: Position)
    func didForceRemove(position: Position)
}

class BubbleGridViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet private var isometricGrid: UICollectionView!

    weak var delegate: DesignDelegate?

    private var bubbles: [Position: Bubble] = [:]
    private var assets: [Type: UIImage] = [:]
    private var selectedIndices = Set<IndexPath>()
    private let maxColumns = 12
    private let maxRows = 12

    override func viewDidLoad() {
        super.viewDidLoad()
        isometricGrid.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(multiSelect)))
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
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updateBubbles)))
        cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(forceDelete)))
        guard let bubbleCell = cell as? BubbleCell else {
            fatalError("Fatal: BubbleCell cannot be used.")
        }
        var sprite: UIImageView? = nil
        if let bubble = bubbles[Position(row: indexPath.section, column: indexPath.item)],
            let image = assets[bubble.getType()] {
            sprite = UIImageView(image: image)
        }
        bubbleCell.setStyle(sprite: sprite)
        return bubbleCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = collectionView.bounds.width / CGFloat(maxColumns)
        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = collectionView.bounds.width / CGFloat(maxColumns * 2 + 1)
        let padding = -inset / 5
        return section % 2 == 0 ? UIEdgeInsets(top: 0, left: 0, bottom: padding, right: 0)
            : UIEdgeInsets(top: 0, left: inset, bottom: padding, right: inset)
    }

    func setGrid(with updatedBubbles: [Position: Bubble], position: Position? = nil, reset: Bool = false) {
        bubbles = updatedBubbles
        if let row = position?.row, let column = position?.column {
            isometricGrid.reloadItems(at: [IndexPath(row: column, section: row)])
        } else if reset {
            isometricGrid.reloadItems(at: isometricGrid.indexPathsForVisibleItems)
        }
    }

    func setAssets(_ assets: [Type: UIImage]) {
        self.assets = assets
    }

    func getPreviewImage() -> UIImage? {
        return collectionView?.getScreenshot()
    }

    @objc
    func updateBubbles(_ recognizer: UITapGestureRecognizer) {
        let tapPosition = recognizer.location(in: isometricGrid)
        if let index = isometricGrid.indexPathForItem(at: tapPosition) {
            delegate?.didSelect(position: Position(row: index.section, column: index.item))
        }
    }

    @objc
    func forceDelete(_ recognizer: UILongPressGestureRecognizer) {
        let position = recognizer.location(in: isometricGrid)
        if let index = isometricGrid.indexPathForItem(at: position), recognizer.state == .began {
            delegate?.didForceRemove(position: Position(row: index.section, column: index.item))
        }
    }

    @objc
    func multiSelect(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            selectedIndices = Set<IndexPath>()
        case .changed:
            let position = recognizer.location(in: isometricGrid)
            if let index = isometricGrid.indexPathForItem(at: position), !selectedIndices.contains(index) {
                selectedIndices.insert(index)
                delegate?.didSelect(position: Position(row: index.section, column: index.item))
            }
        case .ended:
            selectedIndices = Set<IndexPath>()
        default:
            return
        }
    }

}
