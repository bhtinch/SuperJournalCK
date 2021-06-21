//
//  Journal.swift
//  SuperJournalCK
//
//  Created by Benjamin Tincher on 6/21/21.
//

import Foundation
import CloudKit

struct JournalStrings {
    static let recordType = "Journal"
    static let title = "title"
    static let entryRefs = "entryRefs"
}

class Journal {
    let ckRecordID: CKRecord.ID
    let title: String
    let entryRefs: [CKRecord.Reference]?
    
    init(ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), title: String, entryRefs: [CKRecord.Reference]?) {
        self.ckRecordID = ckRecordID
        self.title = title
        self.entryRefs = entryRefs
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[JournalStrings.title] as? String else { return nil }
        
        let entryRefs = ckRecord[JournalStrings.entryRefs] as? [CKRecord.Reference]
        
        self.init(ckRecordID: ckRecord.recordID, title: title, entryRefs: entryRefs)
    }
}   //  End of Class

extension Journal: Equatable {
    static func == (lhs: Journal, rhs: Journal) -> Bool {
        lhs.ckRecordID == rhs.ckRecordID
    }
}   //  End of Extension

//  MARK: - CKRECORD
extension CKRecord {
    convenience init(journal: Journal) {
        self.init(recordType: JournalStrings.recordType, recordID: journal.ckRecordID)
        
        self.setValuesForKeys([
            JournalStrings.title : journal.title
        ])
        
        if let entryRefs = journal.entryRefs {
            self.setValue(entryRefs, forKey: JournalStrings.entryRefs)
        }
    }
}   //  End of Extension
