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
//    var delegate : LibraryTableViewControllerDelegate
    
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            // El optional está vacío: hay que crearla a pelo
            cell = UITableViewCell(style: .Subtitle,
                                   reuseIdentifier: cellId)
        }
        
        // Sincronizar book -> celda
//        cell?.imageView?.image = item.imageURL
        cell?.textLabel?.text  = item.title
        cell?.detailTextLabel?.text = item.listOfAuthors()

        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return model.tags[section].name
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func book(forIndexPath indexPath: NSIndexPath)->Book{
        
        return model.bookAtIndex(indexPath.row, forTag: model.tags[indexPath.section])!
    }

}

//protocol LibraryTableViewControllerDelegate {
//    
//    func libraryTableViewController(vc : LibraryTableViewController, didSelectCharacter character: Book)
//}
