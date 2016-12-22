//
//  ViewController.swift
//  DBFM
//
//  Created by Yiqi Wang on 2016/12/20.
//  Copyright © 2016年 Melody5417. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HttpProtocol {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playTimeLabel: UILabel!
  
    var webController = HttpController()
    
    var tableData:NSArray = NSArray()
    var channelData:NSArray = NSArray()
    var imageCache = Dictionary<String, UIImage>()
    
    var audioPlayer = MPMoviePlayerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webController.delegate = self
        webController.onSearch(urlStr: "http://www.douban.com/j/app/radio/channels")
        webController.onSearch(urlStr: "http://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "douban")
        let rowData: [String : Any] = self.tableData[indexPath.row] as! Dictionary
        
        DispatchQueue.main.async(){
            //歌名
            cell.textLabel?.text = rowData["title"] as? String
            cell.detailTextLabel?.text = rowData["artist"] as? String
            cell.imageView?.image = UIImage(named: "detail.jpg")
            let url = rowData["picture"] as? String
            self.getImage(urlString: url!, imageView: cell.imageView!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var rowData = self.tableData[indexPath.row] as! Dictionary<String, Any>
        let audioURL = rowData["url"] as! String
        onSetAudio(url: audioURL)
        let imageURLString: String = rowData["picture"] as! String
        self.onSetImage(urlString: imageURLString)
    }
    
    // MARK : HttpProtocol
    
    func didReceiveResults(results: NSDictionary) {
        
        /*
         The dataTaskWithRequest call runs in the background and then calls your completion handler from the same thread. Anything that updates the UI should run on the main thread, so all of your current handler code should be within a DispatchQueue.main.async back onto the main queue
         */
        DispatchQueue.main.async(){
            if (results.object(forKey: "song") != nil) {
                self.tableData = results.object(forKey: "song") as! NSArray
                self.tableView.reloadData()
                
                let firstDic = self.tableData[0] as! NSDictionary
                let audioURLString: String = firstDic["url"] as! String
                self.onSetAudio(url: audioURLString)
                let imageURLString: String = firstDic["picture"] as! String
                self.onSetImage(urlString: imageURLString)
                
            } else if (results.object(forKey: "channels") != nil) {
                self.channelData = results.object(forKey: "channels") as! NSArray
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: 获取图片
    
    func getImage(urlString: String, imageView: UIImageView) {
        let image = self.imageCache[urlString] as UIImage?
        if image == nil {
            let url = URL(string:urlString)!
            let req = NSMutableURLRequest(url:url)
            let session = URLSession.shared
            let task = session.dataTask(with: req as URLRequest) { (data, response, error) in
                if data != nil && error == nil {
                    let image: UIImage = UIImage(data: data!)!
                    DispatchQueue.main.async(){
                        imageView.image = image
                    }
                    self.imageCache[urlString] = image
                }
            }
            task.resume()
        } else {
            DispatchQueue.main.async(){
                imageView.image = image
            }
        }
    }
    
    // MARK: 音乐操作
    
    func onSetAudio(url: String) {
        self.audioPlayer.stop()
        self.audioPlayer.contentURL = NSURL(string: url)! as URL!
        self.audioPlayer.play()
    }
    
    func onSetImage(urlString: String) {
        getImage(urlString: urlString, imageView: imageView)
    }

}

