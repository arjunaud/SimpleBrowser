//
//  SearchSuggestionsViewController.swift
//  Browser
//
//  Created by Arjuna on 3/28/21.
//

import UIKit

class SearchSuggestionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchSuggestionsTableView: UITableView!
    
    var searchService:SearchService = SearchServiceProvider()

    var onSearchSuggegestionSelection:((String) -> Void)?
        
    var searchText:String = ""  {
        didSet {
            self.fetchSuggestions()
        }
    }
    
    var searchSuggestions: [Suggestion] = [] {
        didSet {
            self.searchSuggestionsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.searchSuggestionsTableView.keyboardDismissMode = .onDrag
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchSuggestionCell = tableView.dequeueReusableCell(withIdentifier: "SearchSuggestionCell", for: indexPath)
        searchSuggestionCell.textLabel?.text = self.searchSuggestions[indexPath.row].suggestionString
        return searchSuggestionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.onSearchSuggegestionSelection?(self.searchSuggestions[indexPath.row].suggestionString)
    }
    
    func fetchSuggestions() {
        self.searchService.suggestionsFor(query: self.searchText) { (suggestions) in
            DispatchQueue.main.async {
                self.searchSuggestions = suggestions
            }
        }
    }

}
