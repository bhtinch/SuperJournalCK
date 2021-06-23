//
//  ConvsationDetailViewController.swift
//  SuperJournalCK
//
//  Created by Benjamin Tincher on 6/21/21.
//

import UIKit

class JournalDetailViewController: UIViewController {
    //  MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    //  MARK: - PROPERTIES
    var journal: Journal?

    //  MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        if let journal = journal { self.title = journal.title }
        
        fetchEntries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    //  MARK: - ACTIONS
    
    
    //  MARK: - METHODS
    func fetchEntries() {
        guard let journal = journal else { return }
        EntryController.fetchEntries(journal: journal) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entries):
                    print("successfully fetched \(entries?.count ?? 0) entries")
                    self.tableView.reloadData()
                case .failure(let error):
                    print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewEntryDetailVC" {
            guard let destination = segue.destination as? EntryDetailViewController,
                  let journal = journal else { return }
            
            destination.journal = journal
            destination.entry = nil
        }
        
        if segue.identifier == "toSelectedEntryDetailVC" {
            guard let destination = segue.destination as? EntryDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow,
                  let journal = journal  else { return }
            
            destination.journal = journal
            destination.entry = EntryController.entries[indexPath.row]
        }
        
    }
}   //  End of Class

extension JournalDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let entry = EntryController.entries[indexPath.row]
        
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.body
        
        return cell
    }
}   //  End of Extension
