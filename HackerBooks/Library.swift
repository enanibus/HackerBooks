//
//  Library.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 29/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation

class Library {

    //MARK: Utility types
    typealias TagArray              =   [Tag]
    typealias BookArray             =   [Book]
    typealias BookDictionary        =   [Tag : BookArray]
    
    //MARK: - Stored properties
    var dict : BookDictionary = BookDictionary()

    //MARK: - Computed properties
    // Array de libros: método get devuelve los libros ordenados por título
    var books: BookArray{
        get{
            return self.books.sort({$0.title < $1.title})
        }
    }
    
    // Array de etiquetas: método get devuelve las etiquetas ordenadas por nombre
    // y sin repetidos
    var tags: TagArray{
        get{
            return self.dict.keys.sort(<)
        }
    }
    
    // Número total de libros
    var booksCount: Int{
        get{
            return self.books.count
        }
    }
        
    //MARK: - Initialization
        
    // Cantidad de libros que hay en una temática.
    // Si el tag no existe, debe devolver cero
    func bookCountForTag (tag: Tag) -> Int{
        guard let count = self.dict[tag]?.count else{
            return 0
        }
        return count
    }
        
    // Array de los libros (instancias de Book) que hay en 
    // una temática.
    // Un libro puede estar en una o más temáticas. Si no hay
    // libros para una temática, ha de devolver nil
    func booksForTag (tag: Tag?) -> [Book]?{
        guard !(bookCountForTag(tag!) == 0) else{
            return nil
        }
        return self.dict[tag!]
    }
        
    // Un Book para el libro que está en la posición 
    // 'index' de aquellos bajo un cierto tag.
    // Utiliza el método booksForTag
    // Si el índice no existe o el tag no existe, 
    // devuelve nil
    // Devolverá, si todo va bien, el libro nº index de la etiqueta tag
    func bookAtIndex(index: Int,
                     forTag tag: Tag) -> Book?{
        
        let books = self.booksForTag(tag)
        let book = books![index]
        
        return book

    }

    


    
    
    //MARK: - Proxies

    
    //MARK: - Utils
    


}

//MARK: - Equatable & Comparable
//utilizamos el patron de diseño proxy (representante)


//MARK: - Extensiones

