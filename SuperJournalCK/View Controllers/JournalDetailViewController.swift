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

    //  MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //  MARK: - ACTIONS
    
    //  MARK: - METHODS
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}   //  End of Class

extension JournalDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}   //  End of Extension
