//
//  User.swift
//  SuperJournalCK
//
//  Created by Benjamin Tincher on 6/21/21.
//

import Foundation
import CloudKit

struct UserStrings {
    static let recordType = "User"
    static let name = "name"
    static let journalRefs = "journalRefs"
}

class User {
    let ckRecordID: CKRecord.ID
    let name: String
    let journalRefs: [CKRecord.Reference]?
    
    init(ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), name: String, journalRefs: [CKRecord.Reference]?) {
        self.ckRecordID = ckRecordID
        self.name = name
        self.journalRefs = journalRefs
    }
}   //  End of Class

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.ckRecordID == rhs.ckRecordID
    }
}   //  End of Extension


//  MARK: - CKRECORD
extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: UserStrings.recordType, recordID: user.ckRecordID)
        
        self.setValue(user.name, forKey: UserStrings.name)
        
        if let refs = user.journalRefs {
            self.setValue(refs, forKey: UserStrings.journalRefs)
        }
    }
}   //  End of Extension


