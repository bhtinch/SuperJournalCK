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
    static let publicDB = CKContainer.default().publicCloudDatabase
    
    static func createJournalWith(title: String, completion: @escaping(Result<Journal, CKError>) -> Void ) {
        let journal = Journal(title: title, entryRefs: nil)
        
        let record = CKRecord(journal: journal)
        
        publicDB.save(record) { record, error in
            if let error = error {
                print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                return completion(.failure(CKError.createError))
            }
            
            if let record = record {
                
                let reference = CKRecord.Reference(record: record, action: .none)
                
                UserController.updateUserWith(journalRefs: [reference]) { success in
                    DispatchQueue.main.async {
                        switch success {
                        case true:
                            guard let createdJournal = Journal(ckRecord: record) else { return completion(.failure(CKError.createError)) }
                            journals.append(createdJournal)
                            completion(.success(createdJournal))
                        case false:
                            completion(.failure(CKError.createError))
                        }
                    }
                }
            }
        }
    }
    
    static func fetchJournals(completion: @escaping(Result<[Journal]?, CKError>) -> Void ) {
        
        guard let journalRefs = UserController.currentUser?.journalRefs else { return completion(.success(nil)) }
        
        let recordIDs = journalRefs.compactMap { $0.recordID }
        
        let fetchOp = CKFetchRecordsOperation(recordIDs: recordIDs)
        
        fetchOp.fetchRecordsCompletionBlock = { (recordsDict, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                    return completion(.failure(CKError.fetchError))
                }
                
                guard let recordsDict = recordsDict else { return completion(.success(nil)) }
                var records = recordsDict.compactMap { $0.value }
                
                records.sort { $0.modificationDate! < $1.modificationDate! }
                
                for record in records {
                    if let journal = Journal(ckRecord: record) {
                        journals.append(journal)
                    }
                }
                return completion(.success(journals))
            }
        }
        publicDB.add(fetchOp)
    }
}   //  End of Struct
