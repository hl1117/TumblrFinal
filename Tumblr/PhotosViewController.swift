//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Harika Lingareddy on 1/10/18.
//  Copyright © 2017 Harika Lingareddy. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var isMoreDataLoading = false
    var offset = 0
  var posts: [NSDictionary] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        loadMoreData()
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
       
    let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        let post = posts[indexPath.row]
          
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary]{
            
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            
            if let imageUrl = URL(string: imageUrlString!) {
                
                 cell.pictureView.setImageWith(imageUrl)
                
            } else {
            }
           
            
        }
        else{
            
        }
       
        tableView.addInfiniteScrolling(){
            self.tableView.reloadData()
            
            self.tableView.indexPath(for: cell)
        }
        
        tableView.rowHeight = 240
        
        
        
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! PhotoCell
        var destinationVC = segue.destination as! PhotoDetailsViewController
        
        destinationVC.use = cell.pictureView.image
    
    }
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
       
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
        task.resume()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isMoreDataLoading){
            isMoreDataLoading = true
        }
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
            isMoreDataLoading = true
            offset += 1
            loadMoreData()
            
        }
     
    }
    
    func loadMoreData(){
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(offset*self.posts.count)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        print("responseDictionary: \(responseDictionary)")
                        
                        
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        self.posts += responseFieldDictionary["posts"] as! [NSDictionary]
                        
                      
                        self.tableView.reloadData()
                        
                    }
                    
                }
                self.isMoreDataLoading = false
        });
        task.resume()
        
    }
}
