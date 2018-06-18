//
//  ViewController.swift
//  DisplayData
//
//  Created by Sivaramsingh on 12/06/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AudioToolbox
import MBProgressHUD
import AVKit
import AVFoundation


class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    var refreshControl: UIRefreshControl?
    var listArr:[List]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        self.tblView.register(UINib(nibName: "\(DisplayTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "DisplayTableViewCell")
        setRefreshControl()
        self.getResponseData()
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setRefreshControl() {
        //Set refreshController
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(ViewController.startRefresh), for: UIControlEvents.valueChanged)
        self.tblView.addSubview(refreshControl!)
        self.tblView.alwaysBounceVertical = true
        refreshControl?.endRefreshing()
    }
    
   
    
    @objc func startRefresh(_ refreshControl: UIRefreshControl)
    {
        self.getResponseData()
        self.refreshControl!.endRefreshing()
    }
 
    
    func getResponseData ()  {
        
        DispatchQueue.main.async {
          MBProgressHUD.showHUDAddedGlobal()
        }
        
        let urlString = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    MBProgressHUD.dismissGlobalHUD()
                }
                print(error!.localizedDescription)
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    MBProgressHUD.dismissGlobalHUD()
                }
                return
                
            }
            //Implement JSON decoding and parsing
            do {
                let responseStrInISOLatin = String(data: data, encoding: String.Encoding.isoLatin1)
                let jsonvalue = JSON(responseStrInISOLatin!)
                self.title = jsonvalue["title"].stringValue

                guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                    print("could not convert data to UTF-8 format")
                    return
                }
                do {
                    let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format) as AnyObject
                    let json = JSON(responseJSONDict)
                    let arrList = responseJSONDict["rows"] as? [AnyObject]
                    var allLists = [List]()
                    if arrList != nil
                    {
                        for item in arrList! {
                            let listItem = List(object: item)
                            allLists.append(listItem)
                        }
                    }
                    self.listArr = allLists
                    OperationQueue.main.addOperation(){
                        //Do UI stuff here
                        self.tblView.reloadData()
                        self.title = json["title"].stringValue
                    }
                    DispatchQueue.main.async {
                        
                         MBProgressHUD.dismissGlobalHUD()
                    }
                    
                } catch {
                    print(error)
                }
            }
            
            
            }.resume()
    }

    // MARK: - UITableViewDelegate
    
     func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if self.listArr?.count != nil {
            return self.listArr!.count
        }
        else
        {
            return 0
        }
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayTableViewCell", for: indexPath) as! DisplayTableViewCell
        
        let item = self.listArr![indexPath.row]
        cell.lblInfo.text = item.info
        cell.lblName.text = item.title
     
        cell.imgPhoto.af_setImage(
            withURL: NSURL(string:(item.image))! as URL,
            placeholderImage: UIImage(),
            filter: nil,
            imageTransition: .crossDissolve(0.3)
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension 
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    

}

