//
//  EntryError.swift
//  CloudKitJournal
//
//  Created by stanley phillips on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import Foundation

enum EntryError: LocalizedError {
    case ckError(Error)
    case unableToUnwrap
}
