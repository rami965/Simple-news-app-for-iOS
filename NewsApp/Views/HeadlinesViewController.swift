//
//  HeadlinesViewController.swift
//  NewsApp
//
//  Created by MACC on 2/3/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftSpinner
import AlamofireImage

class HeadlinesCell: UITableViewCell {
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    //@IBOutlet weak var details: UILabel!
    //@IBOutlet weak var date: UILabel!
    
    func fetchPreviewImage(imageURL: String?) {
        guard let url = imageURL else {return}
        DispatchQueue.global(qos: .userInitiated).async {
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    DispatchQueue.main.async {
                        self.previewImage.image = image
                    }
                }
            }
        }
    }
}


class HeadlinesViewController: UIViewController {
    
    @IBOutlet weak var headlinesTableView: UITableView!
    
    
    var pageNumber = 0
    var token: Int64?
    var newsList: [NewsObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SwiftSpinner.useContainerView(self.view)
        
        
        getNewToken()

    }

    func getNewToken() {
        let baseURL = URL(string: "http://lowcost-env.pmtiunacvu.us-east-1.elasticbeanstalk.com")!
        var requets = URLRequest(url: baseURL)
        let params = "app_key=demo&app_secret=12345678"
        requets.httpMethod = "POST"
        requets.httpBody = params.data(using: .utf8)
        
        SwiftSpinner.show("Authenticating user...")
        
        Alamofire.request(requets as URLRequestConvertible)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseObject { (response: DataResponse<AuthResponse>) in
                
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        if let isSuccess = JSON.success, isSuccess,
                            let token = JSON.token {

                            print("Token:", token)
                            self.token = token
                            //fetch news
                            self.fetchNews(token: token, page: self.pageNumber)

                        } else if let errorMsg = JSON.msg {
                            //Stop indicator
                            SwiftSpinner.hide()
                            
                            //Show error msg
                            Utils.showAlert(title: "Error", message: errorMsg, vc: self)
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    Utils.showAlert(title: "Error", message: error.localizedDescription, vc: self)
                    SwiftSpinner.hide()
                }
        }
    }
    
    func fetchNews(token: Int64, page: Int?) {
        var baseURL = "http://lowcost-env.pmtiunacvu.us-east-1.elasticbeanstalk.com/?"
        baseURL += "token=\(String(token))"
        baseURL += "&page=\(String(page ?? 0))"
        
        let requestURL = URL(string: baseURL)!
        
        SwiftSpinner.show("Getting news...")
        
        Alamofire.request(requestURL as URLConvertible)
            .responseObject { (response: DataResponse<NewsResponse>) in
                
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        if let isSuccess = JSON.success, isSuccess,
                            let newsList = JSON.data {
                            
                            self.newsList.append(contentsOf: newsList)
                            DispatchQueue.main.async {
                                self.headlinesTableView.reloadData()
                            }
                            
                        } else if let errorMsg = JSON.msg {
                            //Show error msg
                            Utils.showAlert(title: "Error", message: errorMsg, vc: self)
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    Utils.showAlert(title: "Error", message: error.localizedDescription, vc: self)
                }
                
                SwiftSpinner.hide()
        }
    }
    
    private func stringFromHtml(string: String) -> NSAttributedString? {
        do {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
                return str
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
}
/////////////////////////////////////////////////////////////////////////////
extension HeadlinesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame:CGRect (x: 0, y: 0, width: 320, height: 1) ) as UIView
        view.backgroundColor = UIColor.lightGray
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == newsList.count - 1, let savedToken = self.token {
            //last cell
            self.pageNumber += 1
            self.fetchNews(token: savedToken, page: self.pageNumber)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "headlineCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HeadlinesCell
        
//        cell.layer.borderColor = UIColor.darkGray.cgColor
//        cell.layer.borderWidth = 1.0
//        cell.layer.cornerRadius = 10.0
        
        cell.title.text = newsList[indexPath.section].title
        cell.fetchPreviewImage(imageURL: newsList[indexPath.section].main_img)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
        let cell = tableView.cellForRow(at: indexPath) as! HeadlinesCell
        detailsViewController.previewImage = cell.previewImage.image
        detailsViewController.newsTitle = newsList[indexPath.section].title
        detailsViewController.details = newsList[indexPath.section].details
        detailsViewController.section = newsList[indexPath.section].section_name
        detailsViewController.date = newsList[indexPath.section].created_date
        
        self.present(detailsViewController, animated: true)
    }
}
