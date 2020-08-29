//
//  PlantTableViewController.swift
//  WaterMyPlants
//
//  Created by Morgan Smith on 8/19/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit
import CoreData

class PlantTableViewController: UITableViewController {
    @IBOutlet var plantTableView: UITableView!
    let networkController = Networking.sharedNetworkController
    var plants: [Plant] = [] {
        didSet {
            print("list of current user's plants: \(plants)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        plantTableView.dataSource = self
        plantTableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let currentUser =  Networking.sharedNetworkController.currentCDUser
        guard let user = currentUser else { return }
        networkController.fetchUserPlants(with: user) { (error) in
            if let error = error {
                print("error fetching user's plants\(error)")
            }
        }
        plants = networkController.currentUserPlants
        plantTableView.reloadData()
        viewDidLoad()
    }

    // MARK: - Table view data source


    @IBAction func refresh(_ sender: Any) {
        plantTableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as? PlantTableViewCell else { return UITableViewCell() }

        let plant = plants[indexPath.row]
        cell.plant = plant

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let plantToDelete = plants[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            networkController.deletePlantFromServer(plant: plantToDelete)
            plants.removeAll{ $0 == plantToDelete }
            do {
                try moc.save()
            } catch {
                moc.reset()
                NSLog("Error saving managed object context: \(error)")
            }
            DispatchQueue.main.async {
                self.plantTableView.reloadData()
            }
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "plantDetailSegue" {
            if let indexPath = plantTableView.indexPathForSelectedRow, let plantDetailVC = segue.destination as? PlantDetailViewController {
                plantDetailVC.plant = plants[indexPath.row]
            }
        }
    }

}
