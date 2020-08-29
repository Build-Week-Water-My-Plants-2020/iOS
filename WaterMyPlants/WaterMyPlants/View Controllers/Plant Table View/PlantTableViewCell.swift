//
//  PlantTableViewCell.swift
//  WaterMyPlants
//
//  Created by Morgan Smith on 8/19/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit

class PlantTableViewCell: UITableViewCell {
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantLabel: UILabel!
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    
    
    private func updateViews() {
        guard let plant = plant else { return }
        
        plantLabel.text = plant.species
        plantImageView.image = UIImage(contentsOfFile: plant.image ?? "")
   
    }
    
   

}
