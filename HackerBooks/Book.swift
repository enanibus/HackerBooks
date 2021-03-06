//
//  Book.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 29/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import UIKit

class Book : Comparable, Hashable {
    
    //MARK: - Stored properties
    let title       : String
    let authors     : [String]
    var tags        : [Tag]
    let imageURL    : NSURL
    let pdfURL      : NSURL
    
    //MARK: - Wrapper classes
    let cover       : AsyncImage
    let content     : AsyncPdf
    
    //MARK: - Computed properties
    var image : UIImage?{
        get{
            return self.cover.getImage()
        }
    }
    
    var pdf : NSData?{
        get{
            return self.content.getPDF()
        }
    }
    
    var isFavorite  : Bool{
        get{
            return self.hasFavoriteTag()
        }
        set{
            if self.hasFavoriteTag() {                
                self.tags.removeAtIndex(0)
            }else{
                self.tags.insert(Tag(withName: FAVORITES), atIndex: 0)
            }
        }
    }
    
    
    //MARK: - Hashable
    var hashValue: Int {
        return title.hashValue
    }

    //MARK: - Initialization
    init(title : String,
         authors : [String],
         tags : [Tag],
         imageURL : NSURL,
         pdfURL : NSURL){
        self.title = title
        self.authors = authors
        self.tags = tags
        self.imageURL = imageURL
        self.pdfURL = pdfURL
        self.cover = AsyncImage(withURL: self.imageURL,
                                withImage: UIImage(imageLiteral: COVER_FILE))
        self.content = AsyncPdf(withURL: self.pdfURL)
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
    
    //MARK: - Utils
    
    func hasFavoriteTag()->Bool{
        return self.tags.contains(Tag.favoriteBookTag())
    }
    
    func listOfAuthors()->String{
        return self.authors.joinWithSeparator(", ")
    }
    
    func listOfTags()->String{
        return self.tags.flatMap { $0.name }.joinWithSeparator(", ")
    }
    
    
}

//MARK: - Equatable & Comparable
//utilizamos el patron de diseño proxy (representante)
func ==(lhs: Book, rhs: Book) -> Bool{
        
    guard (lhs !== rhs) else{
        return true
    }
    
    guard lhs.dynamicType == rhs.dynamicType else{
        return false
    }
    
    return lhs.proxyForComparison == rhs.proxyForComparison
}

func <(lhs: Book, rhs: Book) -> Bool{
        
    return lhs.proxyForSorting < rhs.proxyForSorting
}

//MARK: - Extensiones
extension Book : CustomStringConvertible{
        
    var description: String {
        get{
            return "<\(self.dynamicType): \(title) -- \(authors) -- \(tags) -- \(imageURL) -- \(pdfURL)>"
        }
    }
}