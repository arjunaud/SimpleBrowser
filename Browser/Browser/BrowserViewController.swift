//
//  ViewController.swift
//  Browser
//
//  Created by Arjuna on 3/28/21.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var searchSuggestionViewController:SearchSuggestionsViewController!
    var searchService:SearchService = SearchServiceProvider()
    var dispatchWorkItem: DispatchWorkItem?

    @IBOutlet weak var webView: WKWebView!
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchSuggestionViewController = self.storyboard?.instantiateViewController(identifier: "SearchSuggestionsViewController") as? SearchSuggestionsViewController
        self.searchSuggestionViewController.searchService = self.searchService
        let searchController = UISearchController(searchResultsController: self.searchSuggestionViewController)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type something here to search"
        self.navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchBarStyle = .minimal;
        self.definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar

        
        self.searchSuggestionViewController.onSearchSuggegestionSelection = { [weak searchController] (searchString) in
            searchController?.isActive = false
            self.loadWebViewWithSearchResutlsForSearchString(searchString: searchString)
        }

        //self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.delegate = self
        self.webView.load(URLRequest(url:URL(string: "https://www.google.com")! ))
    }
    
    func loadWebViewWithSearchResutlsForSearchString(searchString:String) {
       
        self.webView.load(self.searchService.urlRequestForSearchString(searchString: searchString))

    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        let interval: TimeInterval = 0.4 // debouncing interval in milliseconds

        self.searchText = text
        dispatchWorkItem?.cancel()
        dispatchWorkItem = DispatchWorkItem(block: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.searchSuggestionViewController.searchText = strongSelf.searchText
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: dispatchWorkItem!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.loadWebViewWithSearchResutlsForSearchString(searchString: searchText)
        self.navigationItem.searchController?.isActive = false

    }

}

