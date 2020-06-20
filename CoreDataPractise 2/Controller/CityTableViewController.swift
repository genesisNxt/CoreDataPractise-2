//
//  CityTableViewController.swift
//  CoreDataPractise 2
//
//  Created by PARMJIT SINGH KHATTRA on 20/6/20.
//  Copyright © 2020 PARMJIT SINGH KHATTRA. All rights reserved.
//

import UIKit
import CoreData
class CityTableViewController: UITableViewController {

    var city = [City]()
    var selectedState : State? {
        didSet {
            loadCity()
        }
    }
    
    let constant = Constant()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func addCity(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add City", message: "City Name", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCity = City(context: self.context)
            newCity.cityName = textField.text!
            newCity.parentState = self.selectedState
            self.city.append(newCity)
            self.saveCity()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "new city"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveCity() {
        do {
            try context.save()
        } catch  {
            print("Error Saving Context\(error)")
        }
        tableView.reloadData()
    }
    func loadCity(with request: NSFetchRequest<City> = City.fetchRequest() , predicate: NSPredicate? = nil ) {
        let categoryPredicate = NSPredicate(format: "parentState.stateName MATCHES[cd] %@", selectedState!.stateName!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//        request.predicate = compoundPredicate
        do {
           city = try context.fetch(request)
        } catch  {
            print("Error Loading\(error)")
        }
        tableView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return city.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constant.cityCell, for: indexPath)
        cell.textLabel?.text = city[indexPath.row].cityName
        return cell
    }
}
// MARK:- SearchBar
extension CityTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<City> = City.fetchRequest()
        let predicate = NSPredicate(format: "cityName CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "cityName", ascending: true)]
        loadCity(with: request, predicate: predicate)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCity()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
