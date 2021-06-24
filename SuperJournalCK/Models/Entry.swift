//
//  Entry.swift
//  SuperJournalCK
//
//  Created by Benjamin Tincher on 6/21/21.
//

import Foundation
import CloudKit

struct EntryStrings {
    static let recordType = "Entry"
    static let title = "title"
    static let body = "body"
    static let journalRef = "journalRef"
}

class Entry {
    let ckRecordID: CKRecord.ID
    var title: String
    var body: String
    //let journalRef: CKRecord.Reference
    
    init(ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), title: String, body: String) {
        self.ckRecordID = ckRecordID
        self.title = title
        self.body = body
        //self.journalRef = journalRef
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryStrings.title] as? String,
              let body = ckRecord[EntryStrings.body] as? String else { return nil}
        
        self.init(ckRecordID: ckRecord.recordID, title: title, body: body)
    }
}   //  End of Class

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}   //  End of Extension

//  MARK: - CKRECORD
extension CKRecord {
    convenience init(entry: Entry, journal: Journal) {
        self.init(recordType: EntryStrings.recordType, recordID: entry.ckRecordID)
        
        let journalRef = CKRecord.Reference(recordID: journal.ckRecordID, action: .deleteSelf)
        
        self.setValuesForKeys([
            EntryStrings.title : entry.title,
            EntryStrings.body : entry.body,
            EntryStrings.journalRef : journalRef
        ])
    }
}   //  End of Extension
