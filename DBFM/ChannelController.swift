//
//  ChannelController.swift
//  DBFM
//
//  Created by Yiqi Wang on 2016/12/20.
//  Copyright © 2016年 Melody5417. All rights reserved.
//

import UIKit
import QuartzCore

protocol ChannelProtocol {
    func onChangeChannel(channelID: String)
}

class ChannelController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var channelData = NSArray()
    
    var delegate: ChannelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.25) {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "channel")
        let rowData = self.channelData[indexPath.row] as! Dictionary<String, Any>
        cell.textLabel?.text = rowData["name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowData = self.channelData[indexPath.row] as! NSDictionary
        let channelID = rowData["channel_id"] as AnyObject
        let channelIDString = "\(channelID)"
        delegate?.onChangeChannel(channelID: channelIDString)
        self.dismiss(animated: true, completion: nil)
    }
}
