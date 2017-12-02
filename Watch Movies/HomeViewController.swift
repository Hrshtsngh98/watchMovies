//
//  ViewController.swift
//  Watch Movies
//
//  Created by Harshit Singh on 11/28/17.
//  Copyright © 2017 Harshit Singh. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController,UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var webService = WebServiceHandler.sharedInstance
    var page = 1, total_pages = 0, movieName = ""
    var movieList: [Movie] = []
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HOME"
//        movieCollectionView.dataSource = self
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        page = 1;
        total_pages = 1
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text?.count == 0 {
            print("Enter Movie Name")
        } else {
            movieList.removeAll()
            movieName = searchBar.text!
//            webService.getMovieList(name: movieName, page: page, completion: { (arg0) in
//                if let arg = arg0 as? (Int,[Movie]) {
//                    self.total_pages = arg.0
//                    self.movieList = arg.1
//                    DispatchQueue.main.async {
//                        self.movieCollectionView.reloadData()
//                    }
//                }
//            })
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movieList.count > 0 {
            EmptyMessage(message: "")
            return movieList.count
        } else {
            EmptyMessage(message: "Search Movie!")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        let movie = movieList[indexPath.row]
        cell.posterImageView.image = UIImage(named: "default")
        DispatchQueue.global().async {
            if movie.poster_path.count > 0 {
                guard let urlStr = "https://image.tmdb.org/t/p/w500\(movie.poster_path)" as? String, let imgData = try? Data.init(contentsOf: URL(string:urlStr)!) else {
                    DispatchQueue.main.async {
                        cell.posterImageView.image = UIImage(named: "default")
                    }
                    return
                }
                DispatchQueue.main.async {
                    cell.posterImageView.image = UIImage(data: imgData)
                }
            }
        }
        
        cell.nameLabel.text = movie.title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cont = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            cont.movie = movieList[indexPath.row]
            navigationController?.pushViewController(cont, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            page += 1
            if page <= total_pages {
                webService.getMovieList(name: movieName, page: page, completion: { (arg0) in
                    if let arg = arg0 as? (Int,[Movie]) {
                        self.total_pages = arg.0
                        self.movieList += arg.1
                        DispatchQueue.main.async {
                            self.movieCollectionView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    func EmptyMessage(message:String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: movieCollectionView.bounds.size.width, height: movieCollectionView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Helvetica", size: 30)
        messageLabel.sizeToFit()
        movieCollectionView.backgroundView = messageLabel;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

