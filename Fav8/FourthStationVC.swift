//
//  FourthStationVC.swift
//  Fav8
//
//  Created by Administrator on 2018-05-30.
//  Copyright © 2018 Woqomoqo. All rights reserved.
//


import UIKit
import Foundation


class FourthStationVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    struct Structure : Codable {
        let body: [Body]
        struct Body : Codable {
            let text: String
            let URL: String
            let image: String?
        }
    }
    
    
    struct LastStructure: Codable {
        let body: [Body]
        struct Body: Codable {
            let url: String
        }
    }
    
    
    var urlString = String()
    var textArray: [String] = []
    var urlArray: [String] = []
    var itemsIndex: Int!
    var jsonsUrl = String()
    
    
    var stationName  = String()
    var imgArray: [String] = []
    var streamData = String()
    var lastUrlString = String()
    
    
    func customInit(itemsIndex: Int, title: String, url: String) {
        self.itemsIndex = itemsIndex
        self.title = title
        self.jsonsUrl = url
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (textArray.count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! ReusableCell
        
        cell.textLabel?.text = textArray[indexPath.row]
        cell.textLabel?.textColor = #colorLiteral(red: 0.4573513865, green: 0.4083655775, blue: 0.4990750551, alpha: 1)
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedStationName = textArray[indexPath.row]
        let selectedStationUrl = urlArray[indexPath.row]
        let selectedImageUrl = imgArray[indexPath.row]
        
        lastUrlString = selectedStationUrl
        
        let data = try! JSONDecoder().decode(LastStructure.self, from: Data(contentsOf: URL(string: lastUrlString)!))
        
        let streamData =  data.body[0]
        let stream = streamData.url
        
        let imageDataDict:[String: String] = ["name": selectedStationName, "streamUrl": stream, "urlImage": selectedImageUrl]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: imageDataDict)
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlString = self.jsonsUrl
        
        if urlString != "empty" {
            
            let data = try! JSONDecoder().decode(Structure.self, from: Data(contentsOf: URL(string: urlString)!))
            
            for body in data.body {
                textArray.append(body.text)
            }
            for body in data.body {
                urlArray.append(body.URL+"8&render=json")
            }
            
            for body in data.body {
                
                if let image = body.image {
                    imgArray.append(image)
                } else {
                    imgArray.append("no image")
                }
            }
            
        } else {
            dismiss(animated: true, completion: nil)
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let nib = UINib(nibName: "ReusableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "reusableCell")
    }
    
}
