//
//  EntryDetailViewController.swift
//  CloudKitJournal
//
//  Created by stanley phillips on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryBodyTextView: UITextView!
    @IBOutlet weak var clearTextButton: UIButton!
    
    // MARK: - Properties
    var entry: Entry?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        clearTextButton.layer.cornerRadius = 8
        entryBodyTextView.layer.borderWidth = 0.4
        entryBodyTextView.layer.borderColor = UIColor.systemFill.cgColor
        entryBodyTextView.layer.cornerRadius = 8
        updateViews()
        entryTitleTextField.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let entryTitle = entryTitleTextField.text, !entryTitle.isEmpty,
              let entryBody = entryBodyTextView.text else {return presentErrorToUser()}
        
        if let entry = entry {
            EntryController.shared.update(entry: entry, title: entryTitle, body: entryBody) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        self.navigationController?.popViewController(animated: true)
                        print(success)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else {
            EntryController.shared.createEntryWith(title: entryTitle, body: entryBody) { (_) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func clearTextButtonTapped(_ sender: Any) {
        entryTitleTextField.text = ""
        entryBodyTextView.text = ""
    }
    
    @IBAction func mainViewTapped(_ sender: Any) {
        entryTitleTextField.resignFirstResponder()
        entryBodyTextView.resignFirstResponder()
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let entry = entry else {return}
        entryTitleTextField.text = entry.title
        entryBodyTextView.text = entry.body
    }
}//end class

// MARK: - UITextfield Delegate extension
extension EntryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
    }
}
