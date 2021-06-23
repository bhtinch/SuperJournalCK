//
//  EntryDetailViewController.swift
//  SuperJournalCK
//
//  Created by Benjamin Tincher on 6/21/21.
//

import UIKit

class EntryDetailViewController: UIViewController {
    //  MARK: - OUTLETS
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    //  MARK: - PROPERTIES
    var entry: Entry?

    //  MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //  MARK: - ACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, title.isEmpty else { return }
        
        let body = bodyTextView.text ?? "Type here..."
        
        EntryController.createEntryWith(title: title, body: body) { result in
            switch result {
            case .success(let entry):
                print("successfully saved entry with title: \(entry.title).")
                Alerts.presentAlertWith(title: "Success!", message: "Entry Saved.", sender: self)
            case .failure(let error):
                print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
            }
        }
    }
    
    //  MARK: - METHODS
    func updateViews() {
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
    }
}
