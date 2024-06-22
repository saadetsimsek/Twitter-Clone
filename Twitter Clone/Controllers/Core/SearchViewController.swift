//
//  SearchViewController.swift
//  Twitter Clone
//
//  Created by Saadet Şimşek on 28/05/2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search with @usernames"
        return searchController
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.text = "Search for users and get connected"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .placeholderText
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(promptLabel)
        navigationItem.searchController = searchController
       
        searchController.searchResultsUpdater = self
        
        configureConstraints()
    }
    
    private func configureConstraints(){
        
        let promptLabelConstraints = [
            promptLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            promptLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ]
        
        NSLayoutConstraint.activate(promptLabelConstraints)
    }

}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsViewController = searchController.searchResultsController as? SearchResultsViewController
        else{
            return
        }
        
        resultsViewController.update(users: <#T##[TwitterUser]#>)
    }
    
    
}
