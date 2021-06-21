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
        
        return cell
    }
}   //  End of Extension
