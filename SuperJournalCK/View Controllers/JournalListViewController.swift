//
//  ConverstationListViewController.swift
//  SuperJournalCK
//
//  Created by Benjamin Tincher on 6/21/21.
//

import UIKit

class JournalListViewController: UIViewController {
    //  MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    //  MARK: - PROPERTIES

    //  MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        checkUser()
    }
    
    //  MARK: - ACTIONS
    @IBAction func addJournalButtonTapped(_ sender: Any) {
        let alert = Alerts.createAlertWith(title: "Create a new Journal!", message: nil, sender: self, textFieldCount: 1, textFieldPlaceHolderText: ["Journal title..."])
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
            guard let title = alert.textFields?.first?.text, !title.isEmpty else { return alert.dismiss(animated: true, completion: nil) }
            self.createNewJournalWith(title: title)
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true)
    }
    
    //  MARK: - METHODS
    func checkUser() {
        if UserController.currentUser == nil {
            UserController.getCurrentUser { success in
                DispatchQueue.main.async {
                    switch success {
                    case true:
                        self.fetchJournals()
                    case false:
                        print("Unable to check user status")
                    }
                }
            }
        } else {
            fetchJournals()
        }
    }
    
    func fetchJournals() {
        JournalController.fetchJournals { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let journals):
                    print("successfully fetched \(journals?.count ?? 0) journals")
                    self.tableView.reloadData()
                case .failure(let error):
                    print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func createNewJournalWith(title: String) {
        JournalController.createJournalWith(title: title) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("journal created.")
                    self.tableView.reloadData()
                case .failure(let error):
                    print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toJournalDetailVC" {
            guard let destination = segue.destination as? JournalDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            
            destination.journal = JournalController.journals[indexPath.row]
        }
    }
}   //  End of Class

extension JournalListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JournalController.journals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let journal = JournalController.journals[indexPath.row]
        
        cell.textLabel?.text = journal.title
        cell.detailTextLabel?.text = "\(journal.entryRefs?.count ?? 0) Entries"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let journal = JournalController.journals[indexPath.row]
            
            JournalController.deleteJournalWith(journal: journal) { success in
                DispatchQueue.main.async {
                    if success {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
}   //  End of Extension
