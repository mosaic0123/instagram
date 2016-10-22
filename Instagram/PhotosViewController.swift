//
//  ViewController.swift
//  Instagram
//
//  Created by tingting_gao on 10/20/16.
//  Copyright © 2016 tingting_gao. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var postItems: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = 320
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    if let response = responseDictionary["response"] as? NSDictionary {
                        if let posts = response["posts"] as? [NSDictionary] {
                            for object in posts {
                                if let photos = object["photos"] as? [NSDictionary] {
                                    if let original = photos[0]["original_size"] as? NSDictionary{
                                        let imageURL = original["url"] as! String
                                        self.postItems.append(Post(imageURL: imageURL))
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                            for post in self.postItems {
                                                print(post.imageURL)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        });
        task.resume()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath) as! PhotosTableViewCell
        var currentURL = self.postItems[indexPath.row].imageURL!
        cell.postImageView.setImageWith(URL(string: currentURL)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postItems.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

