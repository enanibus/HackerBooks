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

func deleteFavoriteToNSDefault(withBookTitle title: String?){
    let defaults = NSUserDefaults.standardUserDefaults()
    var fav = getFavoritesFromNSDefault()
    if title != nil {
        fav.removeAtIndex((fav.indexOf(title!))!)
        defaults.setObject(fav, forKey: FAVORITES)
        defaults.synchronize()
    }
}

//MARK: - URL resources loading management

func getLocalURL(fromPath path: Directories) throws -> NSURL{
    let fm = NSFileManager.defaultManager()
    var url: NSURL?
    switch path {
        case .Documents :
            url = fm.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last
        case .Cache:
            url = fm.URLsForDirectory(NSSearchPathDirectory.CachesDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last
    }
    guard let localUrl = url else{
        throw HackerBooksError.urlNotFoundError
    }
    return localUrl
}

func loadResource(withUrl url: NSURL) throws -> NSData{
    var data : NSData
    do{
        data = try loadResourceFromCache(withUrl: url)
        return data
    }catch{
        do{
            data = try loadResourceFromUrl(withUrl: url)
            try saveResourceToCache(withUrl: url, andData: data)
            return data
        }
        catch{
            throw HackerBooksError.resourcePointedByURLNotReachable
        }
    }
}

func loadResourceFromCache(withUrl url: NSURL) throws -> NSData{
    do{
        let path = try getLocalURL(fromPath: .Cache)
        guard let resource = url.lastPathComponent else{
            throw HackerBooksError.resourcePointedByURLNotReachable
        }
        let locUrl = path.URLByAppendingPathComponent(resource)
        let data = NSData(contentsOfURL: locUrl)
        guard let localData = data else{
            throw HackerBooksError.resourcePointedByURLNotReachable
        }
        return localData
    }
    catch{
        throw HackerBooksError.resourcePointedByURLNotReachable
    }
}

func loadResourceFromUrl(withUrl url: NSURL) throws -> NSData{
    let data = NSData(contentsOfURL: url)
    guard let urlData = data else{
        throw HackerBooksError.resourcePointedByURLNotReachable
    }
    return urlData
}


func saveResourceToCache(withUrl url: NSURL, andData data: NSData) throws {
    var cacheUrl: NSURL
    let path = try! getLocalURL(fromPath: .Cache)
    cacheUrl = (path.URLByAppendingPathComponent(url.lastPathComponent!))
    guard data.writeToURL(cacheUrl, atomically: true) else{
        print("Failed to saving data in .Cache")
        throw HackerBooksError.resourcePointedByURLNotReachable
    }
}


//MARK: - Utils
