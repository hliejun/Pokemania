//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

protocol TemplateDelegate: class {
    func didLoadTemplate(name: String)
    func didDeleteTemplate(name: String, index: IndexPath)
}

class TemplateViewController: UIViewController, UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet private var templateList: UICollectionView!

    weak var delegate: TemplateDelegate?

    private var templates = [String]()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancelLoad(_ sender: Any) {
        dismiss(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templates.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplateCell", for: indexPath)
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPress)))
        guard let templateCell = cell as? TemplateCell else {
            fatalError("Fatal: TemplateCell cannot be used.")
        }
        let title = templates[indexPath.item]
        let imageView = UIImageView(image: UIImage(contentsOfFile: Storage.getImagePath(for: title)))
        templateCell.setStyle(preview: imageView, title: title)
        return templateCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width
        width = width < 600 ? width - 40 : (width - 80) / 3
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

    func setTemplates(_ templates: [String], deleted index: IndexPath? = nil) {
        self.templates = templates
        if let deletedIndex = index {
            templateList.deleteItems(at: [deletedIndex])
        }
    }

    @objc
    func didTap(_ recognizer: UITapGestureRecognizer) {
        let tapPosition = recognizer.location(in: templateList)
        if let index = templateList.indexPathForItem(at: tapPosition) {
            delegate?.didLoadTemplate(name: templates[index.item])
        }
    }

    @objc
    func didLongPress(_ recognizer: UILongPressGestureRecognizer) {
        let tapPosition = recognizer.location(in: templateList)
        if let index = templateList.indexPathForItem(at: tapPosition), recognizer.state == .began {
            delegate?.didDeleteTemplate(name: templates[index.item], index: index)
        }
    }

}
