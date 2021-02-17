//
//  DateFormatter.swift
//  CloudKitJournal
//
//  Created by stanley phillips on 2/2/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let formattedDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
