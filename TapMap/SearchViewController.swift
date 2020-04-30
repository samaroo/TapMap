//
//  SearchViewController.swift
//  TapMap
//
//  Created by Brandon Samaroo on 1/10/20.
//  Copyright © 2020 Brandon Samaroo. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //global variable that hold the results of the MKLocalSearchCompleter
    var searchResults: [String]?
    
    var searchCompleter: MKLocalSearchCompleter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializing search completer and setting its delegate to this VC
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        
        self.searchBar.delegate = self
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        //overrides user interface style to dark if IOS 13.0 or newer
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchTableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        //setting cell's label to correct info
        cell.searchLabel.text = self.searchResults?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}

extension SearchViewController: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        //get result, transform it to our needs and fill our dataSource
        self.searchResults = completer.results.map { $0.title }
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
            
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        //handle the error
        print(error.localizedDescription)
    }
}

extension SearchViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //change searchCompleter depends on searchBar's text
        if !searchText.isEmpty {
            searchCompleter!.queryFragment = searchText
        }
        else {
            searchResults?.removeAll()
            searchTableView.reloadData()
        }
    }
}
