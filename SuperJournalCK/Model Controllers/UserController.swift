//
//  UserController.swift
//  SuperJournalCK
//
//  Created by Benjamin Tincher on 6/21/21.
//

import Foundation
import CloudKit

struct UserController {
    
    static let privateDB = CKContainer.default().privateCloudDatabase
    static var currentUser: User?
    
    static func getCurrentUser(completion: @escaping(Bool) -> Void) {
        CKContainer.default().fetchUserRecordID(completionHandler: { (recordId, error) in
            DispatchQueue.main.async {
                if let recordID = recordId {
                    print("iCloud ID: " + recordID.recordName)
                    
                    let fetchOp = CKFetchRecordsOperation(recordIDs: [recordID])
                    
                    fetchOp.fetchRecordsCompletionBlock = { (recordsDict, error) in
                        DispatchQueue.main.async {
                            if let error = error {
                                print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                                return completion(false)
                            }
                            
                            guard let recordsDict = recordsDict,
                                  let  record = recordsDict.first?.value else { return completion((false)) }
                            
                            if let currentUser = User(ckRecord: record) {
                                self.currentUser = currentUser
                                print("current user fetched: \(currentUser.journalRefs?.count ?? 0) journals with id => '\(currentUser.ckRecordID.recordName)'")
                                return completion((true))
                            }
                        }
                    }
                    privateDB.add(fetchOp)
                    
                } else if let error = error {
                   print(error.localizedDescription)
                    return completion(false)
                }
            }
        })
    }
    
    static func updateUserWith(journalRefs: [CKRecord.Reference]?, completion: @escaping(Bool) -> Void) {
        if let currentUser = currentUser {
            currentUser.journalRefs = journalRefs
            
            let record = CKRecord(user: currentUser)
            
            let modifyOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            modifyOperation.savePolicy = .changedKeys
            modifyOperation.modifyRecordsCompletionBlock = { (records, _, error) in
                if let error = error {
                    print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                    return completion(false)
                } else {
                    completion(true)
                }
            }
            privateDB.add(modifyOperation)
        }
    }
}   //  End of Struct
