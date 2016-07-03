//
//  Errors.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 29/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation

// MARK: -  JSON Errors
enum HackerBooksError : ErrorType{
    case wrongURLFormatForJSONResource
    case resourcePointedByURLNotReachable
    case jsonParsingError
    case wrongJSONFormat
    case nilJSONObject
}