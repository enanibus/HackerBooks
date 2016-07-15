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
        pdfViewer.delegate = self
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        syncModelWithView()
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
    
        activityView.startAnimating()
        activityView.hidden = false
        renderContentOfPDF()
    }


    //MARK: - UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        
        // Parar el activity view
        activityView.stopAnimating()
        
        // Ocultarlo
        activityView.hidden = true
        
    }
    
    
    //MARK: - UIWebView & rendering of pdf 
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == .LinkClicked || navigationType == .FormSubmitted{
            return false
        }else{
            return true
        }
    }
    
    func renderContentOfPDF(){
        let  download = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
        let bloque : dispatch_block_t = {
            guard let pdf = self.model.pdf else{
                self.pdfViewer.loadHTMLString("NO PDF AVAILABLE FOR BOOK!, SORRY FOR THE INCONVENIENCE", baseURL: NSURL())
                return
            }
            self.pdfViewer.loadData(pdf,
                                    MIMEType: "application/pdf",
                                    textEncodingName: "UTF-8",
                                    baseURL: NSURL())
        }
        dispatch_async(download, bloque)
    }


}
