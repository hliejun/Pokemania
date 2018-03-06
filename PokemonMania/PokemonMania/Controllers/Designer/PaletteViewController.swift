//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

protocol PaletteDelegate: class {
    func didUpdateEditToggle(_ editMode: EditMode)
    func didUpdateBubbleOption(_ type: Type?)
}

enum EditMode: String {
    case select, cycle, remove
}

class PaletteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet private var bubblePalette: UIView!
    @IBOutlet private var bubbleOptions: UICollectionView!
    @IBOutlet private var cycleButton: UIButton!
    @IBOutlet private var editButton: UIButton!
    weak var delegate: PaletteDelegate?
    private var assets: [Type: UIImage] = [:]
    private var labels: [Type] = []
    private var editMode: EditMode = .select

    override func viewDidLoad() {
        super.viewDidLoad()
        bubblePalette.layer.cornerRadius = bubblePalette.frame.height / CGFloat(2)
        bubbleOptions.layer.cornerRadius = bubbleOptions.frame.height / CGFloat(2)
        bubbleOptions.allowsMultipleSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaletteView", for: indexPath)
        let imageView = UIImageView(image: assets[labels[indexPath.row]])
        imageView.frame = CGRect(origin: CGPoint.zero, size: cell.bounds.size)
        cell.addSubview(imageView)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didUpdateBubbleOption(labels[indexPath.row])
    }

    func getLabels() -> [Type] {
        return labels
    }

    func setPalette(_ assets: [Type: UIImage]) {
        self.assets = assets
        var energies = [Type](), effects = [Type](), obstacles = [Type](), creatures = [Type](), balls = [Type]()
        self.assets.forEach { label, _ in
            switch label {
            case .energyType:
                energies.append(label)
            case .effectType:
                effects.append(label)
            case .obstacleType:
                obstacles.append(label)
            case .creatureType:
                creatures.append(label)
            case .ballType:
                balls.append(label)
            }
        }
        self.labels = [] + energies + effects + obstacles + creatures + balls
    }

    private func rotateButton(of sender: UIButton, by angle: Double,
                              for duration: Double = Animations.duration.rawValue * 0.5) {
        UIView.animate(withDuration: duration) {
            sender.transform = sender.transform.rotated(by: CGFloat(angle))
        }
    }

    private func setPaletteStyle(for editMode: EditMode) {
        let isSelecting = editMode == .select
        bubbleOptions.allowsSelection = isSelecting
        bubbleOptions.alpha = isSelecting ? 1.0 : 0.5
        bubbleOptions.isScrollEnabled = isSelecting
        cycleButton.isUserInteractionEnabled = editMode != .remove
        cycleButton.tintColor = editMode == .cycle ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        editButton.tintColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
    }

    @IBAction func toggleEditing(_ sender: UIButton) {
        var angle = -5 * Double.pi / 4
        switch editMode {
        case .select:
            editMode = sender == cycleButton ? .cycle : .remove
        case .remove:
            editMode = .select
            angle = -angle
        case .cycle:
            editMode = sender == cycleButton ? .select : .remove
        }
        if sender == editButton {
            rotateButton(of: sender, by: angle)
        }
        if editMode == .cycle {
            delegate?.didUpdateBubbleOption(nil)
        }
        setPaletteStyle(for: editMode)
        delegate?.didUpdateEditToggle(editMode)
    }

}
