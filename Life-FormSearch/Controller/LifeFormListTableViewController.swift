//
//  SearchResutlsTableViewController.swift
//  Life-FormSearch
//
//  Created by Long Tran on 12/03/2024.
//

import UIKit

class LifeFormListTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var lifeForms = [LifeForm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
       
    }
    
    func fetchLifeForms(){
        lifeForms = []
        tableView.reloadData()
        
        let textSearching = searchBar.text ?? ""
        
        if !textSearching.isEmpty{
            Task{
                do{
                    let lifeForms = try await LifeFormController.shared.fetchLifeForms(for: textSearching)
                    self.lifeForms = lifeForms
                    tableView.reloadData()
                }catch{
                    print(error)
                }
                
            }
        }
    }
 
   
    @IBSegueAction func showDetailLifeForm(_ coder: NSCoder, sender: Any?) -> LifeFormDetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else{
            return nil
        }
        
        let idLifeForm = lifeForms[indexPath.row].identifier
        
        return LifeFormDetailViewController(coder: coder, idLifeForm: idLifeForm)
    }
    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return lifeForms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lifeForm = lifeForms[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text  = lifeForm.scientificName
        content.secondaryText = lifeForm.commonName
        cell.contentConfiguration = content
        return cell
    }


    // MARK: - Navigation

 

}

extension LifeFormListTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchLifeForms()
        tableView.resignFirstResponder()
    }
}
