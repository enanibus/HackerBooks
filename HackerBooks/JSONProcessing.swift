//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 30/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import UIKit

//MARK: - JSON Properties
enum JSONDictionaryKeys: String{
    case AUTHORS = "authors"
    case IMAGE_URL  = "image_url"
    case PDF_URL = "pdf_url"
    case TAGS = "tags"
    case TITLE = "title"
}

/*
 {
 "authors": "Scott Chacon, Ben Straub",
 "image_url": "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg",
 "pdf_url": "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf",
 "tags": "version control, git",
 "title": "Pro Git"
 }
 */

//MARK : - Aliases
typealias JSONObject        =   AnyObject
typealias JSONDictionary    =   [String : JSONObject]
typealias JSONArray         =   [JSONDictionary]


//MARK: - Decodification
func decode(book json: JSONDictionary) throws  -> Book{
    
    // Validamos el dict
    
    guard let authorsString = json[JSONDictionaryKeys.AUTHORS.rawValue] as? String else{
        throw HackerBooksError.wrongJSONFormat
    }
    
        let authors = authorsStringToArray(authorsString)
    
    guard let imageURLString = json[JSONDictionaryKeys.IMAGE_URL.rawValue] as? String,
        imageURL = NSURL(string : imageURLString) else{
            throw HackerBooksError.resourcePointedByURLNotReachable
    }
    
    guard let pdfURLString = json[JSONDictionaryKeys.PDF_URL.rawValue] as? String,
        pdfURL = NSURL(string : pdfURLString) else{
            throw HackerBooksError.resourcePointedByURLNotReachable
    }
    
    guard let tagsString = json[JSONDictionaryKeys.TAGS.rawValue] as? String else{
        throw HackerBooksError.wrongJSONFormat
    }
    
        let tags = tagsStringToArray(tagsString)
    
    guard let title = json[JSONDictionaryKeys.TITLE.rawValue] as? String else{
        throw HackerBooksError.wrongJSONFormat
    }
    
    
    return Book(title: title, authors: authors, tags: tags, imageURL: imageURL, pdfURL: pdfURL)
}

func decode(book json: JSONDictionary?) throws -> Book{
    
    if case .Some(let jsonDict) = json{
        return try decode(book: jsonDict)
    }else{
        throw HackerBooksError.nilJSONObject
    }
}


//MARK: - Utils

//Conversión "authorsString" en [String]

func authorsStringToArray(string: String)->[String]{
    let authors = string.componentsSeparatedByString(",")
    var authorsArray = [String]()
    for eachAuthor in authors{
        authorsArray.append(eachAuthor.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
    }
    return authorsArray
}

//Conversión "tagsString" en [Tag]

func tagsStringToArray(string: String)->[Tag]{
    let tags = string.componentsSeparatedByString(",")
    var tagsArray = [Tag]()
    for eachTagString in tags{
        let tag = Tag(withName: eachTagString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        tagsArray.append(tag)
    }
    return tagsArray
}


//MARK: - Loading
func loadFromLocalFile(fileName name: String, bundle: NSBundle = NSBundle.mainBundle()) throws -> JSONArray{
    
    if let url = bundle.URLForResource(name),
        data = NSData(contentsOfURL: url),
        maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
        array = maybeArray{
        
        return array
        
    }else{
        throw HackerBooksError.jsonParsingError
    }
}

func loadFromURL() throws -> JSONArray{
    
    if let url = NSURL(string: "https://t.co/K9ziV0z3SJ"),
        data = NSData(contentsOfURL: url),
        maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
        array = maybeArray{
        
        return array
        
    }else{
        throw HackerBooksError.jsonParsingError
    }
}


//MARK: - Downloading

func downloadFromURL() throws -> NSData{
    
    let data = NSData(contentsOfURL: NSURL(string: "https://t.co/K9ziV0z3SJ")!)
    
    guard let json = data else{
        throw HackerBooksError.resourcePointedByURLNotReachable
    }
    
    return json
}







