//
//  EntryController.swift
//  SuperJournalCK
//
//  Created by Benjamin Tincher on 6/21/21.
//

import Foundation
import CloudKit

struct EntryController {
    static var entries: [Entry] = []
    static let publicDB = CKContainer.default().publicCloudDatabase
    
    static func createEntryWith(title: String, body: String, completion: @escaping(Result<Entry, CKError>) -> Void ) {
        let entry = Entry(title: title, body: body)
        
        let record = CKRecord(entry: entry)
        
        publicDB.save(record) { record, error in
            if let error = error {
                print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                return completion(.failure(CKError.createError))
            }
            
            if let record = record {
                guard let entry = Entry(ckRecord: record) else { return completion(.failure(CKError.createError)) }
                entries.append(entry)
                completion(.success(entry))
            }
        }
    }
    
    static func fetchEntries(journal: Journal, completion: @escaping(Result<[Entry]?, CKError>) -> Void ) {
        
        let journalRef = CKRecord.Reference(recordID: journal.ckRecordID, action: .none)
        
        let predicate = NSPredicate(format: "%K == %@", EntryStrings.journalRef, journalRef)
        
        let query = CKQuery(recordType: EntryStrings.recordType, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                return completion(.failure(CKError.fetchError))
            }
            
            guard var records = records else { return completion(.failure(CKError.fetchError)) }
            
            records.sort { $0.modificationDate! < $1.modificationDate! }
            
            entries = records.compactMap { Entry(ckRecord: $0) }
            
            completion(.success(entries))
        }
    }
}
