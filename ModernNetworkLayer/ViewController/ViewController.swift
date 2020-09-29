//
//  ViewController.swift
//  ModernNetworkLayer
//
//  Created by Moises Hernandez Zamarripa on 29/09/20.
//  Copyright © 2020 cjapps. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var networkManager: NetworkManager!
    
    var movies: [Movie] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    init(networkManager: NetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.networkManager = networkManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        refreshControl?.beginRefreshing()
        self.getMovies()
    }
    
    func show(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func refresh() {
        self.getMovies()
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.movies[indexPath.row].title
        return cell
    }
}

extension ViewController {
    func getMovies() {
        self.networkManager.getNewMovies(page: 1) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if self.refreshControl?.isRefreshing ?? false {
                    self.refreshControl?.endRefreshing()
                }
                switch result {
                case .success(let response):
                    self.movies = response.results
                case .failure(let error):
                    self.show(error: error.rawValue)
                }
            }
        }
    }
}

