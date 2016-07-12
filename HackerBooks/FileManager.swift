//
//  DataManager.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 8/7/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation

enum Directories{
    case Documents
    case Cache
}


//MARK: - NSUserDefaults & Favorites management

func setDefaults(){
    let defaults = NSUserDefaults.standardUserDefaults()
    let fav = defaults.arrayForKey(FAVORITES)
    
    defaults.setObject(JSON_DOWNLOADED, forKey: JSON_DOWNLOADED)
    defaults.setObject(fav, forKey: FAVORITES)
    defaults.synchronize()
}

func getFavoritesFromNSDefault() -> [String]{
    let defaults = NSUserDefaults.standardUserDefaults()
    guard let fav = defaults.arrayForKey(FAVORITES) as? [String] else{
        return []
    }
    return fav
}

func addFavoriteToNSDefault(withBookTitle title: String){
    let defaults = NSUserDefaults.standardUserDefaults()
    var fav = getFavoritesFromNSDefault()
        fav.append(title)
        defaults.setObject(fav, forKey: FAVORITES)
        defaults.synchronize()
}

func deleteFavoriteToNSDefault(withBookTitle title: String){
    let defaults = NSUserDefaults.standardUserDefaults()
    var fav = getFavoritesFromNSDefault()
        fav.removeAtIndex((fav.indexOf(title))!)
        defaults.setObject(fav, forKey: FAVORITES)
        defaults.synchronize()
}

//MARK: - URL resources loading management

func getUrlLocal(fromPath path: Directories) throws -> NSURL{
    let fm = NSFileManager.defaultManager()
    var url: NSURL?
    switch path {
        case .Documents :
            url = fm.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last
        case .Cache:
            url = fm.URLsForDirectory(NSSearchPathDirectory.CachesDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last
    }
    guard let theUrl = url else{
        throw HackerBooksError.urlNotFoundError
    }
    return theUrl
}

//MARK: - Utils
