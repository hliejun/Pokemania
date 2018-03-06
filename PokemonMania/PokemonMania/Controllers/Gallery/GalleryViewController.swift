//  Created by Huang Lie Jun on 5/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet private var levelList: UICollectionView!
    private var levels: [String: Stage] = [:]
    private var gameControl: GameViewController?
    private var stageToSegue: Stage = Stage()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? GameViewController {
            gameControl = controller
            gameControl?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        levels = Storage.read(.levels, as: [String: Stage].self) ?? [:]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelView", for: indexPath)
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        guard let levelCell = cell as? TemplateView else {
            fatalError("Fatal: LevelView cannot be used.")
        }
        if let level = levels[String(format: "%02d", indexPath.item + 1)] {
            let title = level.getTitle()
            let imageView = UIImageView(image: UIImage(contentsOfFile: Storage.getImagePath(for: title)))
            levelCell.setStyle(preview: imageView, title: title)
        }
        return levelCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGFloat
        let margin: CGFloat = Style.largeMargin.rawValue
        let tableWidth = collectionView.bounds.width
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            cellSize = floor((tableWidth - (4 * margin)) / 3)
        default:
            cellSize = floor(tableWidth - (2 * margin))
        }
        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = Style.largeInset.rawValue
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    @IBAction func cancelLoad(_ sender: Any) {
        dismiss(animated: true)
    }

    @objc
    func didTap(_ recognizer: UITapGestureRecognizer) {
        let tapPosition = recognizer.location(in: levelList)
        if let index = levelList.indexPathForItem(at: tapPosition),
            let level = levels[String(format: "%02d", index.item + 1)] {
            stageToSegue = Stage(from: level)
            self.performSegue(withIdentifier: "StartGameFromGallery", sender: recognizer.view)
        }
    }

}

extension GalleryViewController: GameDelegate {

    func getGameStage() -> Stage {
        return stageToSegue
    }

}
