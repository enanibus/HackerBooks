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
    typealias TagArray              =   [String]
    typealias BookArray             =   [Book]
    typealias BookSet               =   Set<Book>
    typealias BookDictionary        =   [String : BookSet]
    
    //MARK: - Stored properties
    var dict : BookDictionary = BookDictionary()

    //MARK: - Computed properties
    // Array de libros: método get devuelve los libros ordenados por título
    var books : BookArray{
        get{
            return self.books.sort({$0.title < $1.title})
        }
        set{
            newValue
        }
    }
    
    // Array de etiquetas: método get devuelve las etiquetas ordenadas por nombre
    // y sin repetidos
    var tags: TagArray{
        get{
            return self.dict.keys.sort(<)
        }
    }
    
    // Número de etiquetas
    var tagsCount : Int{
        get{
            return self.dict.count
        }
    }
    
    // Número total de libros
    var booksCount: Int{
        get{
            return self.books.count
        }
    }
    
    //MARK: - Initialization
    
    init(){

        do{
            let jsonArray = try loadFromURL()
//            print(json)
            
//            var bookArray = BookArray()
            
            try initLibrary(withJSONArray: jsonArray)
            
//            for eachDict in json{
//                do{
//                    let eachBook = try decode(book: eachDict)
//
//                    for eachTag in eachBook.tags{
//                        var booksWithTag = BookSet()
//                        if let hasTags = self.dict[eachTag]{
//                            booksWithTag = hasTags
//                        }
//                        booksWithTag.insert(eachBook)
//                        self.dict[eachTag] = booksWithTag
//                    }
//                    
//                }catch{
//                    print("Error al procesar \(eachDict)")
//                }
//            }
            
//            print(bookArray.description)
//            loadDictionary(withBookArray: bookArray)
            
//            print(self.dict.count)
//            print(bookCountForTag("java"))
//            print(bookCountForTag("javascript"))
//            print(bookCountForTag("programming"))
//            print(self.dict)

//            for (key, value) in self.dict {
//                print("Dictionary key \(key) -  Dictionary value \(value)")
//            }

            
        }catch{
            print("Error en la carga de JSON")
        }
        
    }
    
    
    //MARK: - Library methods
    
    // Cantidad de libros que hay en una temática.
    // Si el tag no existe, debe devolver cero
    func bookCountForTag (tag: String?) -> Int{
        if let tagName = tag {
            return self.dict[tagName]!.count
        }
        return 0
    }
    

    // Array de los libros (instancias de Book) que hay en
    // una temática.
    // Un libro puede estar en una o más temáticas. Si no hay
    // libros para una temática, ha de devolver nil
    func booksForTag (tag: String?) -> BookSet?{
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
                     forTag tag: String?) -> Book?{
        
        let books = self.booksForTag(tag)
        return books![(books?.startIndex.advancedBy(index))!]

    }
    
    // Tag name: return tag's name
    func tagName(tag: Tag) -> String{
        return tag.name
    }
    
    
    //MARK: - CRUD(C,D) + notificaciones de cambios en el modelo
    
    //Añadir libro a la etiqueta
    func addBookForTag(book: Book, tag: String) {
        
        self.dict[tag]?.insert(book)
        
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: LIBRARY_DID_CHANGE_NOTIFICATION, object: nil))
    }
    
    
    // Elimina libro de la etiqueta
    func removeBookForTag(book: Book, tag: String) {
        
        self.dict[tag]?.removeAtIndex((dict[tag]?.indexOf(book))!)
        
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: LIBRARY_DID_CHANGE_NOTIFICATION, object: nil))
    }
    
    
    //MARK: - Utils
    
    func makeEmptyDictionary() ->  BookDictionary {
        
        return BookDictionary()
    }
    
    func initLibrary (withJSONArray jsonArray: JSONArray) throws{
        
//        self.books = BookArray()
        
        for eachDict in jsonArray{
            do{
                let eachBook = try decode(book: eachDict)
                
//                self.books.append(eachBook)
    
                for eachTag in eachBook.tags{
                    var booksWithTag = BookSet()
                    if let hasTags = self.dict[eachTag]{
                        booksWithTag = hasTags
                    }
                    booksWithTag.insert(eachBook)
                    self.dict[eachTag] = booksWithTag
                }
    
            }catch{
                    throw HackerBooksError.jsonParsingError
            }
        }
    
        print(self.dict.count)
        print(bookCountForTag("java"))
        print(bookCountForTag("javascript"))
        print(bookCountForTag("programming"))
        //            print(self.dict)
    
        for (key, value) in self.dict {
        print("Dictionary key \(key) -  Dictionary value \(value)")
        }
    }
    
}


//MARK: - Extensiones

