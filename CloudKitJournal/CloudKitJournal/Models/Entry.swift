//
//  Entry.swift
//  CloudKitJournal
//
//  Created by stanley phillips on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import CloudKit

struct EntryStrings {
    static let titleKey = "title"
    static let bodyKey = "body"
    static let timestampKey = "timestamp"
    static let recordType = "entry"
}

class Entry {
    var title: String
    var body: String
    let timestamp: Date
    let ckRecord: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), ckRecord: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecord = ckRecord
    }
}//end class

// MARK: - Extensions
extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryStrings.recordType, recordID: entry.ckRecord)
        self.setValuesForKeys([
            EntryStrings.titleKey : entry.title,
            EntryStrings.bodyKey : entry.body,
            EntryStrings.timestampKey : entry.timestamp
        ])
    }
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.ckRecord == rhs.ckRecord
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryStrings.titleKey] as? String,
              let body = ckRecord[EntryStrings.bodyKey] as? String,
              let timestamp = ckRecord[EntryStrings.timestampKey] as? Date else {return nil}
        self.init(title: title, body: body, timestamp: timestamp, ckRecord: ckRecord.recordID)
    }
}

