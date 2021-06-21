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
}

class Entry {
    let ckRecordID: CKRecord.ID
    let title: String
    let body: String
    
    init(ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), title: String, body: String) {
        self.ckRecordID = ckRecordID
        self.title = title
        self.body = body
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
    convenience init(entry: Entry) {
        self.init(recordType: EntryStrings.recordType, recordID: entry.ckRecordID)
        
        self.setValuesForKeys([
            EntryStrings.title : entry.title,
            EntryStrings.body : entry.body
        ])
    }
}   //  End of Extension
