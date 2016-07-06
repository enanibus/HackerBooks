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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Alta en notificación
//        let nc = NSNotificationCenter.defaultCenter()
//        nc.addObserver(self, selector: #selector(characterDidChange), name: CharacterDidChangeNotification, object: nil)
        
        
        syncModelWithView()
    }
    
    //MARK: Sync Model & View
    func syncModelWithView(){
        pdfViewer.delegate = self
        activityView.startAnimating()
        pdfViewer.loadData(model.pdf!,
                           MIMEType: "application/pdf",
                           textEncodingName: "UTF-8",
                           baseURL: NSURL())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        
        // Parar el activity view
        activityView.stopAnimating()
        
        // Ocultarlo
        activityView.hidden = true
        
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == .LinkClicked || navigationType == .FormSubmitted{
            return false
        }else{
            return true
        }
    }


}
