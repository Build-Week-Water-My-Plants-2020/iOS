//
//  PlantTableViewController.swift
//  WaterMyPlants
//
//  Created by Morgan Smith on 8/19/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit

class PlantTableViewController: UITableViewController {
    @IBOutlet var plantTableView: UITableView!
    var plants = [Plant]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem
        }
        
        // MARK: - Table view data source
        
        
    @IBAction func refresh(_ sender: Any) {
        plantTableView.reloadData()
    }
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return plants.count
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as? PlantTableViewCell else { return UITableViewCell() }
            
            let plant = plants[indexPath.row]
            cell.plant = plant
            
            
            
            return cell
        }
        
        
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "userSegue" {
                if let addUserVC = segue.destination as? UserDetailViewController {
                    
                    
                   
                }
            } else if segue.identifier == "addPlantSegue" {
                if let addPlantVC = segue.destination as? PlantDetailViewController {
                    
                } else if segue.identifier == "plantDetailSegue" {
                    if let indexPath = tableView.indexPathForSelectedRow, let plantDetailVC = segue.destination as? PlantDetailViewController {
                   
                    }
                }
                
            }
            
            
            
        }
        
        
    }

   


// Question: So now that we have merged the remote repo on Github, do we need to pull so the project in our local repo (on our computer) get those changes.
