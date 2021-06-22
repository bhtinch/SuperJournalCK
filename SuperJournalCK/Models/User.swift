//
//  User.swift
//  SuperJournalCK
//
//  Created by Benjamin Tincher on 6/21/21.
//

import Foundation
import CloudKit

struct UserStrings {
    static let recordType = "Users"
    static let journalRefs = "journalRefs"
}

class User {
    let ckRecordID: CKRecord.ID
    var journalRefs: [CKRecord.Reference]?
    
    init(ckRecordID: CKRecord.ID, journalRefs: [CKRecord.Reference]?) {
        self.ckRecordID = ckRecordID
        self.journalRefs = journalRefs
    }
    
    convenience init?(ckRecord: CKRecord) {
        let journalRefs = ckRecord[UserStrings.journalRefs] as? [CKRecord.Reference]
        
        self.init(ckRecordID: ckRecord.recordID, journalRefs: journalRefs)
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
                
        if let refs = user.journalRefs {
            self.setValue(refs, forKey: UserStrings.journalRefs)
        }
    }
}   //  End of Extension


