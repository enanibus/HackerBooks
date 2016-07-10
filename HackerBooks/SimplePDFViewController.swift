//
//  SimplePDFViewController.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 30/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class SimplePDFViewController: UIViewController, UIWebViewDelegate {
    
    //MARK: Properties
    var model : Book

    @IBOutlet weak var pdfViewer: UIWebView!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    init(model: Book){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activityView.hidden = true
        syncModelWithView()
        // Alta en notificación
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self,
                       selector: #selector(bookDidChange),
                       name: BOOK_DID_CHANGE_NOTIFICATION, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Baja en las notificaciones
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
    }
    
    
    //MARK: Utils
    func bookDidChange(notification: NSNotification){
        
        // Sacar el userInfo
        let info = notification.userInfo!
        
        // Sacar el libro
        let book = info[BOOK_KEY] as? Book
        
        // Actualizar el modelo
        model = book!
        
        // Sincronizar las vistas
        syncModelWithView()
        
    }
    
    func syncModelWithView(){
        pdfViewer.delegate = self
        activityView.startAnimating()
        pdfViewer.loadData(model.pdf!,
                           MIMEType: "application/pdf",
                           textEncodingName: "UTF-8",
                           baseURL: NSURL())
        
    }


    //MARK: - UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        
        // Parar el activity view
        activityView.stopAnimating()
        
        // Ocultarlo
        activityView.hidden = true
        
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == .LinkClicked || navigationType == .FormSubmitted{
            return false
        }else{
            return true
        }
    }


}
