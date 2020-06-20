//
//  ViewController.swift
//  CoreDataPractise 2
//
//  Created by PARMJIT SINGH KHATTRA on 20/6/20.
//  Copyright © 2020 PARMJIT SINGH KHATTRA. All rights reserved.
//

import UIKit
import CoreData

class StateViewController: UIViewController {

    var state = [State]()
    let constant = Constant()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadState()
    }
    // MARK:- Add Methods
    @IBAction func addState(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New State", message: "Indian State", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newState = State(context: self.context)
            newState.stateName = textField.text
            newState.done = false
            self.state.append(newState)
            self.saveState()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add State"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    // MARK:- save function
    func saveState() {
        do {
            try context.save()
        } catch {
            print("Error saving\(error)")
        }
        tableView.reloadData()
    }
    // MARK:- load function
    func loadState() {
        let request: NSFetchRequest<State> = State.fetchRequest()
        do {
           state = try context.fetch(request)
        } catch  {
            print("Error Loading\(error)")
        }
    }
}
// MARK:- Tableview DataSource Methods
extension StateViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constant.stateCell , for: indexPath)
        cell.textLabel?.text = state[indexPath.row].stateName
        return cell
    }
}
// MARK:- TableView Delegate Methods
extension StateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: constant.goToCity, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CityTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedState = state[indexPath.row]
        }
    }
}

