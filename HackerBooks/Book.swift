//
//  Book.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 29/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation


class Book : Comparable {
    
    //MARK: - Stored properties
    let title       : String
    let authors     : [String]
    let tags        : [Tag]
    let imageURL    : NSURL
    let pdfURL      : NSURL
    var isFavorite  : Bool
    
    
    //MARK: - Computed properties

    
    //MARK: - Initialization
    init(title : String,
         authors : [String],
         tags : [Tag],
         imageURL : NSURL,
         pdfURL : NSURL,
         isFavorite : Bool){
        self.title = title
        self.authors = authors
        self.tags = tags
        self.imageURL = imageURL
        self.pdfURL = pdfURL
        self.isFavorite = isFavorite
    }
    
    
    //MARK: - Proxies
    var proxyForComparison : String{
        get{
            return "\(title)"
        }
    }
    
    var proxyForSorting : String{
        get{
            return proxyForComparison
        }
    }
    
}

    //MARK: - Equatable & Comparable
    //utilizamos el patron de diseño proxy (representante)
    func ==(lhs: Book, rhs: Book) -> Bool{
        
        guard (lhs !== rhs) else{
            return true
        }
        
        return lhs.proxyForComparison == rhs.proxyForComparison
    }

    func <(lhs: Book, rhs: Book) -> Bool{
        
        return lhs.proxyForSorting < rhs.proxyForSorting
    }



    extension Book : CustomStringConvertible{
        
        var description: String {
            get{
                return "<\(self.dynamicType)\(title) -- \(authors) -- \(tags)>"
            }
        }
    }