//
//  LibraryTableViewController.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 30/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

let DidChangeNotification = "Selected Book did change"
let BookKey = "key"

class LibraryTableViewController: UITableViewController {
    
    //MARK: - Properties
    let model : Library
    var delegate : LibraryTableViewControllerDelegate?
    
    //MARK: - Initialization
    init(model: Library){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HackerBooks"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Averiguar cual es el libro
        let item = book(forIndexPath: indexPath)
        
        // Crear un BookVC
        let bookVC = BookViewController(model: item)
        
        // Hacerle un push
        navigationController?.pushViewController(bookVC, animated: true)
        
        // Enviamos la misma info via notificaciones
//        let nc = NSNotificationCenter.defaultCenter()
//        let notif = NSNotification(name: DidChangeNotification, object: self, userInfo: [BookKey:theBook])
//        nc.postNotification(notif)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.tagsCount
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.bookCountForTag(model.tags[section])
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Tipo de celda
        let cellId = "BookCell"
        
        // Averiguar el libro
        let item = book(forIndexPath: indexPath)
        
        // Crear la celda
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil{
            // El optional está vacío: hay que crear la celda a pelo
            cell = UITableViewCell(style: .Subtitle,
                                   reuseIdentifier: cellId)
        }
        
        // Sincronizar book -> celda
        cell?.imageView?.image = item.photo
        cell?.textLabel?.text  = item.title
        cell?.detailTextLabel?.text = item.listOfAuthors()

        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return model.tags[section].name.capitalizedString
    }
        
    func book(forIndexPath indexPath: NSIndexPath)->Book{
        
        return model.bookAtIndex(indexPath.row, forTag: model.tags[indexPath.section])!
    }

}

protocol LibraryTableViewControllerDelegate {
    
    func libraryTableViewController(vc : LibraryTableViewController, didSelectBook book: Book)
}
