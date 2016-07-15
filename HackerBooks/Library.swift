//
//  Library.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 29/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import UIKit

class Library {

    //MARK: Utility types
    typealias TagArray              =   [Tag]
    typealias BookArray             =   [Book]
    typealias BookSet               =   Set<Book>
    typealias BookDictionary        =   [Tag : BookSet]
    
    //MARK: - Stored properties
    var dict        : BookDictionary = BookDictionary()
    var booksArray  : BookArray = BookArray()

    //MARK: - Computed properties
    // Array de libros: método get devuelve los libros ordenados por título
    var books : BookArray{
        get{
            return self.booksArray.sort({$0.title < $1.title})
        }
        set{
            booksArray = newValue
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
            let jsonArray = try loadFromDocuments()
            
            try initLibrary(withJSONArray: jsonArray)
            
        }catch{
            print(HackerBooksError.jsonParsingError)
        }
        
        subscribeNotificationsTagDidChange()
    }
    
    deinit {

        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
    }
    
    
    //MARK: - Library methods
    
    // Cantidad de libros que hay en una temática.
    // Si el tag no existe, debe devolver cero
    func bookCountForTag (tag: Tag) -> Int{
        if !self.tags.contains(tag){
            return 0
        }
        guard let count = self.dict[tag]?.count else {
            return 0
        }
        return count
    }
    

    // Array de los libros (instancias de Book) que hay en
    // una temática.
    // Un libro puede estar en una o más temáticas. Si no hay
    // libros para una temática, ha de devolver nil
    func booksForTag (tag: Tag) -> BookSet?{
        guard !(bookCountForTag(tag) == 0) else{
            return nil
        }
        return self.dict[tag]

    }
        
    // Un Book para el libro que está en la posición 
    // 'index' de aquellos bajo un cierto tag.
    // Utiliza el método booksForTag
    // Si el índice no existe o el tag no existe, 
    // devuelve nil
    // Devolverá, si todo va bien, el libro nº index de la etiqueta tag
    func bookAtIndex(index: Int,
                     forTag tag: Tag) -> Book?{
        
        guard let _:Int = index else{
            return nil
        }
        
        guard let books = self.booksForTag(tag) else{
            return nil
        }
        
        return books[(books.startIndex.advancedBy(index))]
    }
    
    func bookAtIndexBooksArray(index: Int) -> Book?{
        
        guard let _:Int = index else{
            return nil
        }
        
        return books[index]
    }
    
    
    // Tag name: return tag's name
    func tagName(tag: Tag) -> String{
        return tag.name
    }
    
    
    //MARK: - CRUD(C,D) -> provocan notificaciones de cambios en el modelo
    
    //Añadir libro a la etiqueta
    func addBookForTag(book: Book, tag: Tag) {
        if self.dict[tag] == nil {
            dict[tag] = BookSet()
        }
        self.dict[tag]?.insert(book)
    }
    
    // Elimina libro de la etiqueta
    func removeBookForTag(book: Book, tag: Tag) {
        if self.dict[tag] == nil{
            return
        }

        self.dict[tag]?.remove(book)

        // Si la etiqueta FAVORITES no tiene libros, elimina su entrada del diccionario
        if (tag == Tag.favoriteBookTag()) && (bookCountForTag(tag) == 0) {
            var cleanDict = makeEmptyDictionary()
            cleanDict = deleteFavoriteTagFromSet(self.dict)
            self.dict = cleanDict
        }

    }
    
    
    //MARK: - Utils
    
    func makeEmptyDictionary() ->  BookDictionary {
        
        return BookDictionary()
    }
    
    func initLibrary (withJSONArray jsonArray: JSONArray) throws{
        
        let fav = getFavoritesFromNSDefault()
        self.booksArray = BookArray()
        
        for eachDict in jsonArray{
            do{
                let eachBook = try decode(book: eachDict)
                
                if fav.contains(eachBook.title) {
                    eachBook.isFavorite = true
                }
                
                self.booksArray.append(eachBook)
    
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
        
    }
    
    func isFavorite(book: Book?) -> Bool{
        guard let fav = book else{
            return false
        }
        return (fav.isFavorite)
    }
    
    func deleteFavoriteTagFromSet(dict: BookDictionary) -> BookDictionary{
        let arrayOfTuplesWithoutFavorites =
            dict.filter { $0.0 != Tag(bookTagWithName: FAVORITES) }
        
        var dictWithoutTagFavorites = makeEmptyDictionary()
        
        for each in arrayOfTuplesWithoutFavorites{
            dictWithoutTagFavorites[each.0] = each.1
        }
        
        return dictWithoutTagFavorites
    }
    
    //MARK: - Notificaciones
    
    // Se apunta a notificaciones de cambio de tag FAVORITES
    func subscribeNotificationsTagDidChange(){
        // Alta en notificación
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self,
                        selector: #selector(notifyFavoriteDidChange),
                        name: TAG_DID_CHANGE_NOTIFICATION,
                        object: nil)
    }
    
    // Notifica cambio de favoritos en el modelo
    @objc func notifyFavoriteDidChange(notification: NSNotification){
        
        // Sacar el userInfo
        let info = notification.userInfo!
        
        // Obtener el libro
        let book = info[BOOK_KEY] as? Book
        
        // Se añade/quita de la entrada de favoritos del diccionario        
        if isFavorite(book) {
            addBookForTag(book!, tag: Tag(bookTagWithName: FAVORITES))
            addFavoriteToNSDefault(withBookTitle: book!.title)
        }
        else{
            removeBookForTag(book!, tag: Tag(bookTagWithName: FAVORITES))
            deleteFavoriteToNSDefault(withBookTitle: book!.title)
        }
        
        // Notifica a los suscriptores del cambio de favorito en el modelo
        notifySuscriptorsFavoritesDidChange()
        
    }
    
    func notifySuscriptorsFavoritesDidChange(){
        let nc = NSNotificationCenter.defaultCenter()
        let notif = NSNotification(name: FAVORITES_DID_CHANGE_NOTIFICATION, object: self)
        nc.postNotification(notif)
    }

}


//MARK: - Extensions

