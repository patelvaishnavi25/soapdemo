//
//  ViewController.swift
//  soap_demo
//
//  Created by TOPS on 8/14/18.
//  Copyright © 2018 TOPS. All rights reserved.
//

import UIKit

class ViewController: UIViewController,XMLParserDelegate {
    
    var strdata = "";
    
    @IBOutlet weak var input_1: UITextField!
    
    @IBOutlet weak var input_2: UITextField!
    
    @IBOutlet weak var result: UITextField!

    @IBOutlet weak var lbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func btnclk(_ sender: Any) {
        
        let url = URL(string: "http://www.dneonline.com/calculator.asmx")
        
        var request = URLRequest(url: url!)
        
        let strbody = "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><Add xmlns=\"http://tempuri.org/\"><intA>\(input_1.text!)</intA><intB>\(input_2.text!)</intB></Add></soap:Body></soap:Envelope>"
        
        request.addValue("http://tempuri.org/Add", forHTTPHeaderField: "SOAPAction");
        
        request.addValue(String(strbody.characters.count), forHTTPHeaderField: "Content-Length");
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST";
        
        request.httpBody = strbody.data(using: String.Encoding.utf8);
        
        let session = URLSession.shared;
        
        let datatask = session.dataTask(with: request){(data1,resp,err) in
            
            var strrsp = String(data: data1!, encoding: String.Encoding.utf8);
            
            print(strrsp);
            
            let parse = XMLParser(data: data1!)
            
            parse.delegate = self;
            
            parse.parse();
        }
        
        datatask.resume();
        
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "AddResult" {
            DispatchQueue.main.async {
                self.result.text = self.strdata;
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        strdata = string;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

