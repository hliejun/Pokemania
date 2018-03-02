//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

enum AlertType {
    case delete, load, reset, save
}

protocol ActionDelegate: class {
    func didReset()
    func didLoad(with templateName: String)
    func didDelete(with templateName: String, index: IndexPath)
    func didSave(with templateName: String)
}

class ActionsViewController: UIViewController {
    weak var delegate: ActionDelegate?

    private var templateControl: TemplateViewController?
    private var saveAlert: UIAlertController?
    private var resetAlert: UIAlertController?
    private var deleteAlert: UIAlertController?
    private var loadAlert: UIAlertController?

    private var templates = [String]()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination.childViewControllers.first as? TemplateViewController {
            templateControl = controller
            templateControl?.delegate = self
            templateControl?.setTemplates(templates)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func saveDesign(_ sender: Any) {
        saveAlert = createAlert(ofType: .save)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let title = self.saveAlert?.textFields?.first?.text {
                self.delegate?.didSave(with: title)
            }
        }
        saveAlert?.addTextField { textField in
            textField.placeholder = "Enter level title..."
            textField.addTarget(self, action: #selector(self.textDidChange), for: .editingChanged)
        }
        saveAlert?.addAction(saveAction)
        saveAlert?.actions[1].isEnabled = false
        if let alert = saveAlert {
            present(alert, animated: true)
        }
    }

    @IBAction func resetDesign(_ sender: Any) {
        resetAlert = createAlert(ofType: .reset)
        resetAlert?.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in self.delegate?.didReset() })
        if let alert = resetAlert {
            present(alert, animated: true)
        }
    }

    @IBAction func cancelLoad(_ sender: Any) {
        dismiss(animated: true)
    }

    @objc
    func textDidChange(_ textField: UITextField) {
        saveAlert?.actions[1].isEnabled = isValidLevelTitle(textField.text)
    }

    func setSavedLevels(with savedLevels: [String], deleted index: IndexPath? = nil) {
        templates = savedLevels
        templateControl?.setTemplates(templates, deleted: index)
    }

    private func createAlert(ofType type: AlertType) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        switch type {
        case .delete:
            alert.title = "Delete Level"
            alert.message = "Are you sure you want to delete this level design?"
        case .load:
            alert.title = "Load Level"
            alert.message = "You are about to load a level design. Any unsaved changes will be lost. Continue?"
        case .reset:
            alert.title = "Reset Level"
            alert.message = "Are you sure you want to reset? Any unsaved changes will be lost."
        case .save:
            alert.title = "Save Level"
            alert.message = "You are about to save a level design. Please give this masterpiece a title."
        }
        return alert
    }

    private func isValidLevelTitle(_ input: String?) -> Bool {
        guard let text = input else {
            return false
        }
        do {
            let regex = try NSRegularExpression(pattern: "[^a-zA-Z0-9_]+", options: .caseInsensitive)
            let range = NSRange(location: 0, length: text.count)
            let matches = regex.matches(in: text, options: [.withoutAnchoringBounds], range: range)
            return !text.isEmpty
                && !templates.contains(text)
                && matches.isEmpty
        } catch {
            return false
        }
    }

}

extension ActionsViewController: TemplateDelegate {

    func didLoadTemplate(name: String) {
        loadAlert = createAlert(ofType: .load)
        loadAlert?.addAction(UIAlertAction(title: "Load", style: .destructive) { _ in
            self.delegate?.didLoad(with: name)
            self.templateControl?.dismiss(animated: true)
        })
        if let alert = loadAlert {
            templateControl?.present(alert, animated: true)
        }
    }

    func didDeleteTemplate(name: String, index: IndexPath) {
        deleteAlert = createAlert(ofType: .delete)
        deleteAlert?.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.delegate?.didDelete(with: name, index: index)
        })
        if let alert = deleteAlert {
            templateControl?.present(alert, animated: true)
        }
    }

}
