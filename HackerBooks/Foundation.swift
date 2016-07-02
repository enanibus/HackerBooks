//
//  Foundation.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 30/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation

extension NSBundle{
    
    func URLForResource(name: String?) -> NSURL?{
        
        let components = name?.componentsSeparatedByString(".")
        let fileTitle = components?.first
        let fileExtension = components?.last
        
        return URLForResource(fileTitle, withExtension: fileExtension)
    }
    
}