//
//  SearchResultsViewController.swift
//  Twitter Clone
//
//  Created by Saadet Şimşek on 22/06/2024.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    var users: [TwitterUser] = []
    
    private let searchResultsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchResultsTableView)
    
        configureConstraints()
        searchResultsTableView.dataSource = self

    }
    
    func update(users: [TwitterUser]) {
        self.users = users
        DispatchQueue.main.async {
            self.searchResultsTableView.reloadData()
        }
    }
    
    private func configureConstraints(){
        
        let searchResultsTableViewConstraints = [
            searchResultsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(searchResultsTableViewConstraints)
    }



}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.displayName
        return cell
    }

}
