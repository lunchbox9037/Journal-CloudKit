//
//  EntryController.swift
//  CloudKitJournal
//
//  Created by stanley phillips on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import CloudKit

class EntryController {
    // MARK: - Properties
    static let shared = EntryController()
    var entries: [Entry] = []
    let privateDB = CKContainer.default().privateCloudDatabase
        
    // MARK: - CRUD
    func createEntryWith(title: String, body: String, completion: @escaping (Result<Entry?, EntryError>) -> Void) {
        let entry = Entry(title: title, body: body)
        save(entry: entry, completion: completion)
    }
    
    func save(entry: Entry, completion: @escaping (Result<Entry?, EntryError>) -> Void) {
        let ckRecord = CKRecord(entry: entry)
        privateDB.save(ckRecord) { (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("======== ERROR ========")
                    print("Function: \(#function)")
                    print("Error: \(error)")
                    print("Description: \(error.localizedDescription)")
                    print("======== ERROR ========")
                    return completion(.failure(.ckError(error)))
                }
                
                guard let record = record,
                      let entry = Entry(ckRecord: record) else {return completion(.failure(.unableToUnwrap))}
                self.entries.append(entry)
                completion(.success(entry))
            }
        }
    }
    
    func fetchEntriesWith(completion: @escaping(Result<[Entry],EntryError>) -> Void) {
        let fetchAllPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryStrings.recordType , predicate: fetchAllPredicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("======== ERROR ========")
                    print("Function: \(#function)")
                    print("Error: \(error)")
                    print("Description: \(error.localizedDescription)")
                    print("======== ERROR ========")
                    return completion(.failure(.ckError(error)))
                }
                
                guard let records = records else {return completion(.failure(.unableToUnwrap))}
                self.entries = records.compactMap {Entry(ckRecord: $0)}
                completion(.success(self.entries))
            }
        }
    }
    
    //update entry here
    func update(entry: Entry, title: String, body: String, completion: @escaping (Result<String, EntryError>) -> Void) {
        entry.title = title
        entry.body = body        
        privateDB.fetch(withRecordID: entry.ckRecord) { (record, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
            }
            
            if let recordToSave = record {
                recordToSave.setValue(title, forKey: EntryStrings.titleKey)
                recordToSave.setValue(body, forKey: EntryStrings.bodyKey)
                
                let modifyRecord = CKModifyRecordsOperation(recordsToSave: [recordToSave], recordIDsToDelete: nil)
                modifyRecord.savePolicy = CKModifyRecordsOperation.RecordSavePolicy.changedKeys
                self.privateDB.add(modifyRecord)
                completion(.success("updated"))
            }
        }
    }
    
    func delete(entry: Entry, completion: @escaping (Result<String, EntryError>) -> Void) {
        let ckRecord = CKRecord(entry: entry)
        privateDB.delete(withRecordID: ckRecord.recordID) { (_, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("======== ERROR ========")
                    print("Function: \(#function)")
                    print("Error: \(error)")
                    print("Description: \(error.localizedDescription)")
                    print("======== ERROR ========")
                    return completion(.failure(.ckError(error)))
                }
                
                guard let index = self.entries.firstIndex(of: entry) else {return completion(.failure(.unableToUnwrap))}
                self.entries.remove(at: index)
                completion(.success("Successfully deleted!"))
            }
        }
    }
}//end class
