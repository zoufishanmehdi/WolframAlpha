//
//  ViewController.swift
//  TryingXML
//
//  Created by C4Q on 5/8/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit
import SWXMLHash

class ViewController: UIViewController{
    
    @IBOutlet weak var queryTextField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    
    //let urlstring = "http://www.nasa.gov/rss/dyn/breaking_news.rss"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadParser()
        
    }
    
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//    
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
//        
//        cell.textLabel!.text = items[indexPath.row]
//        
//        return cell
//    }
    
    //MARK - parser
    var textInput: String? {
        swapSpace(String(queryTextField.text!))
        return self.textInput
    }
    
    func swapSpace(str: String) -> String {
        
        return str.stringByReplacingOccurrencesOfString(" ", withString: "%20")
    }
    
    
    func createURLWithString(text: String) -> NSURL? {
        var urlString: String = "http://api.wolframalpha.com/v2/query?appid=V5V6Y4-PUVA3WGWQ2&"
        
        // append params
        urlString = urlString.stringByAppendingString("input=how%20many%20")
        urlString = urlString.stringByAppendingString(textInput!)
        urlString = urlString.stringByAppendingString("%20fill%20up%20the%20moon")
        
        return NSURL(string: urlString)
    }
    
    
    //let urlstring = "http://api.wolframalpha.com/v2/query?appid=V5V6Y4-PUVA3WGWQ2&input=how%20many%20m%26ms%20fill%20up%20the%20moon"
    
    var items:[String] = []
    
    func loadParser(){
        
      // let request = NSMutableURLRequest(URL: NSURL(string: urlstring)!)
        
        let request = NSMutableURLRequest(URL:(createURLWithString(textInput!))!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            
            if data == nil {
                print("dataTaskWithRequest error: \(error)")
                return
            }
            
            func pars(){
                let xml = SWXMLHash.parse(data!)
                
                for elem in xml["queryresult"]["pod"][1]["subpod"] {
                    
                    self.items.append((elem["plaintext"].element?.text)!)
                    
                }

                self.answerLabel.text = String(self.items)
                
//                for elem in xml["rss"]["channel"]["item"] {
//                    
//                    self.items.append((elem["title"].element?.text)!)
//                    
//                }
                
                //reload data after fetch
               // self.tableView.reloadData()
                
                
            }
            //sending async task
            dispatch_async(dispatch_get_main_queue(), pars)
            
            
        }
        task.resume()
        
    }
    
    
}
