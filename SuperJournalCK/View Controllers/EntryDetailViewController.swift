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
    var journal: Journal?
    var entry: Entry?

    //  MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //  MARK: - ACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
        print("saved button tapped.")
        
        guard let title = titleTextField.text, !title.isEmpty,
              let journal = journal else { return }
        
        let body = bodyTextView.text ?? "Type here..."
        
        if entry == nil {
            saveNewEntry(title: title, body: body, journal: journal)
        } else {
            updateCurrentEntry(title: title, body: body, journal: journal)
        }
    }
    
    //  MARK: - METHODS
    func updateViews() {
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
    }
    
    func saveNewEntry(title: String, body: String, journal: Journal) {
        EntryController.createEntryWith(title: title, body: body, journal: journal) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entry):
                    print("successfully saved entry with title: \(entry.title).")
                    Alerts.presentAlertWith(title: "Success!", message: "Entry Saved.", sender: self)
                case .failure(let error):
                    print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateCurrentEntry(title: String, body: String, journal: Journal) {
        EntryController.update(entry: entry!, journal: journal, title: title, body: body) { success in
            DispatchQueue.main.async {
                if success {
                    print("entry successfully updated.")
                    Alerts.presentAlertWith(title: "Success!", message: "Entry Saved.", sender: self)
                } else {
                    print("***Error*** in Function: \(#function)\n\nError saving entry.")
                }
            }
        }
    }
}
