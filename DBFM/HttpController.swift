//
//  HttpController.swift
//  DBFM
//
//  Created by Yiqi Wang on 2016/12/20.
//  Copyright © 2016年 Melody5417. All rights reserved.
//

import UIKit

protocol HttpProtocol {
    func didReceiveResults(results: NSDictionary)
}

class HttpController: NSObject {
    
    var delegate: HttpProtocol?
    
    func onSearch(urlStr: String) {
        let url = URL(string:urlStr)!
        let req = NSMutableURLRequest(url:url)
        let session = URLSession.shared
        let task = session.dataTask(with: req as URLRequest) { (data, response, error) in
            do {
                if error == nil && data != nil {
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                    self.delegate?.didReceiveResults(results: jsonResult)
                }
            }
            catch {
                
            }
        }
        task.resume()
    }
}
