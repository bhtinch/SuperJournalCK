//
//  CKError.swift
//  SuperJournalCK
//
//  Created by Benjamin Tincher on 6/21/21.
//

import Foundation

enum CKError: LocalizedError {
    case thrownError(Error)
    case fetchError
    case createError
}
