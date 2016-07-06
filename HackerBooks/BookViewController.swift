//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 30/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var authorsView: UILabel!
    
    @IBOutlet weak var tagsView: UILabel!
    
    var model : Book
    
    //MARK: - Initialization
    init(model: Book){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    func syncModelWithView(){
        
        // Photo
        photoView.image = model.photo
        
        // Title
        title = model.title
        
        // Authors
        authorsView.text = model.listOfAuthors()
        
        // Tags
        tagsView.text = model.listOfTags().capitalizedString
    }

    @IBAction func readPDF(sender: AnyObject) {
        
        // Crear un ReadVC
        let readVC = SimplePDFViewController(model: model)
        
        // Hacer un push sobre NavigationController
        navigationController?.pushViewController(readVC, animated: true)
    }
    
    
    @IBAction func markAsFavorite(sender: AnyObject) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Antes de que la vista tenga sus dimensiones
        // Una sola vez
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // Para que el VC se ajuste al espacio que deja
        // el navigation
        // edgesForExtendedLayout = .None
        
        // Justo antes de montrarse (después de viewDidLoad)
        // Posiblemente más de una vez
        syncModelWithView()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

}

extension BookViewController: LibraryTableViewControllerDelegate{
    
    func libraryTableViewController(vc:LibraryTableViewController, didSelectBook book: Book) {
        
        
        // Actualizar el modelo
        model = book
        
        // Sincronizar las vistas con el nuevo modelo
        syncModelWithView()
        
    }
}
