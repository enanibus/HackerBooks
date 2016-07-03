//
//  Tag.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 29/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation

class Tag : Comparable, Hashable {
    
    //MARK: - Stored properties
    var name: String
    
    //MARK: - Computed properties
    var isFavorite : Bool{
        get{
            return name == FAVORITES
        }
    }
    
    //MARK: - Hashable
    var hashValue: Int {
        return name.hashValue
    }
    
    //MARK: - Initializers
    init(withName name: String){
        self.name = name
    }
    
    convenience init (bookTagWithName name: String){
        self.init(withName: name)
    }
    
    //MARK: - Class methods
    class func favoriteBookTag()->Tag{
        return Tag(withName: FAVORITES)
    }
    
    //MARK: - Proxies
    var proxyForComparison : String{
        get{
            return "\(name)"
        }
    }
    
    var proxyForSorting : String{
        get{
            return proxyForComparison
        }
    }
    
    //MARK: - Utils
    func tagName(name: String)->String{
        return self.name.lowercaseString.capitalizedString
    }
    
}

//MARK: - Equatable & Comparable

func ==(lhs: Tag, rhs: Tag) -> Bool {
    
    guard (lhs !== rhs) else{
        return true
    }
    
    guard lhs.dynamicType == rhs.dynamicType else{
        return false
    }
    
    return lhs.proxyForComparison == rhs.proxyForComparison
}

func <(lhs: Tag, rhs: Tag) -> Bool{
    
    if lhs.isFavorite {
        return true
    }
    
    if rhs.isFavorite {
        return false
    }
    
    return (lhs.proxyForSorting < rhs.proxyForSorting)
}

//MARK: - Extensions
extension Tag: CustomStringConvertible{
    
    var description: String{
        
        get{
            return "<\(self.dynamicType): \(name)>"
        }
    }
}