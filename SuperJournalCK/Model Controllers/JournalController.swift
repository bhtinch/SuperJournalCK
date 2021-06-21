//
//  JournalController.swift
//  SuperJournalCK
//
//  Created by Benjamin Tincher on 6/21/21.
//

import Foundation
import CloudKit

struct JournalController {
    static var journals: [Journal] = []
    static let publicDB = CKContainer.default().privateCloudDatabase
    
    static func createJournalWith(title: String, completion: @escaping(Result<Journal, CKError>) -> Void ) {
        let journal = Journal(title: title, entryRefs: nil)
        
        let record = CKRecord(journal: journal)
        
        publicDB.save(record) { record, error in
            if let error = error {
                print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                return completion(.failure(CKError.createError))
            }
            
            if let record = record {
                guard let createdJournal = Journal(ckRecord: record) else { return completion(.failure(CKError.createError)) }
                journals.append(createdJournal)
                completion(.success(createdJournal))
            }
        }
    }
}
