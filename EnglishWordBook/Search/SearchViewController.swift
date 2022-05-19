//
//  ViewController.swift
//  EnglishWordBook
//
//  Created by Алексей Гончаров on 4/27/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let presenter: SearchPresenter
    private let tableView = UITableView()
    private var wordData: WordData?
    
    init(presenter: SearchPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.barStyle = .default
        setupViews()
        setupLayout()
        setupSearchController()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "bgColor")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .systemMint
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupSearchController() {
        let searchBar = UISearchController()
        navigationItem.searchController = searchBar
        searchBar.searchBar.delegate = self
    }
    
    func show(wordData: WordData) {
        self.wordData = wordData
        tableView.reloadData()
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let meaning = wordData!.meanings[indexPath.row]
        var list = UIListContentConfiguration.subtitleCell()
        list.text = meaning.partOfSpeech
        list.secondaryText = meaning.firstDefinition?.definition
        cell.contentConfiguration = list
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        wordData?.meanings.count ?? 0
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        presenter.didSearch(text: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        wordData = nil
        tableView.reloadData()
    }
}

