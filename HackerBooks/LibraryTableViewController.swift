//
//  LibraryTableViewController.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 30/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

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
        self.edgesForExtendedLayout = .None
        
        // Botón para elegir ordenación Tag o Title
        let segment: UISegmentedControl = UISegmentedControl(items: [TAG, TITLE])
        segment.sizeToFit()
        segment.selectedSegmentIndex = ORDER_BY_TAG
        let frame = UIScreen.mainScreen().bounds
        segment.frame = CGRectMake(frame.minX + 5, frame.minY + 25,
                                    frame.width - 10, frame.height*0.05)
        segment.layer.cornerRadius = 5.0
//        segment.backgroundColor = UIColor.blackColor()
//        segment.tintColor = UIColor.whiteColor()
        segment.addTarget(self,
                     action: #selector(switchOrderBy),
                     forControlEvents: .ValueChanged)
        self.navigationItem.titleView = segment

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
        
        // Avisar al delegado
        delegate?.libraryTableViewController(self, didSelectBook: item)
        
        // Enviamos la misma info via notificaciones
        self.notifySelectedBookDidChange(item)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Alta en notificacines de cambios en los modelos
        self.suscribeNotificationsFavoritesDidChange()
        
        self.subscribeNotificationsImageDidChange()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Baja en las notificaciones
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch self.model.orderBy {
            case ORDER_BY_TAG:
                return model.tagsCount
            case ORDER_BY_TITLE:
                return 1
            default:
                return model.tagsCount
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.model.orderBy {
            case ORDER_BY_TAG:
                return model.bookCountForTag(model.tags[section])
            case ORDER_BY_TITLE:
                return model.booksCount
            default:
                return model.bookCountForTag(model.tags[section])
        }
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
        cell?.imageView?.image = item.cover.getImage()
        cell?.textLabel?.text  = item.title
        cell?.detailTextLabel?.text = item.listOfAuthors()

        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch self.model.orderBy {
            case ORDER_BY_TAG:
                return model.tags[section].name.capitalizedString
            case ORDER_BY_TITLE:
                return LITERAL_SECTION_ORDER_BY_TITLE
            default:
                return model.tags[section].name.capitalizedString
        }
        
    }
        
    func book(forIndexPath indexPath: NSIndexPath)->Book{
        switch self.model.orderBy {
            case ORDER_BY_TAG:
                return model.bookAtIndex(indexPath.row, forTag: model.tags[indexPath.section])!
            case ORDER_BY_TITLE:
                return model.bookAtIndexBooksArray(indexPath.row)!
            default:
                return model.bookAtIndex(indexPath.row, forTag: model.tags[indexPath.section])!
        }  
    }
    
    
    //MARK: - Notificaciones
    
    func notifySelectedBookDidChange(withBookSelected: Book){
        let nc = NSNotificationCenter.defaultCenter()
        let notif = NSNotification(name: BOOK_DID_CHANGE_NOTIFICATION,
                                   object: self,
                                   userInfo: [BOOK_KEY:withBookSelected])
        nc.postNotification(notif)
    }
    
    func suscribeNotificationsFavoritesDidChange(){
        // Alta en notificación
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(favoriteDidChange),
                       name: FAVORITES_DID_CHANGE_NOTIFICATION,
                       object: nil)
    }
    
    func favoriteDidChange(notification: NSNotification){
        self.tableView.reloadData()
    }
    
    func subscribeNotificationsImageDidChange(){
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(imageDidChange),
                       name: IMAGE_DID_CHANGE_NOTIFICATION,
                       object: nil)
    }
    
    func imageDidChange(notification: NSNotification){
        self.tableView.reloadData()
    }
    
    //MARK: - Switch ORDER BY TAG / ORDER BY TITLE
    
    func switchOrderBy(sender: UISegmentedControl) {
        self.model.orderBy = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
}

//MARK: - Delegate
protocol LibraryTableViewControllerDelegate {
    
    func libraryTableViewController(vc : LibraryTableViewController, didSelectBook book: Book)
}
