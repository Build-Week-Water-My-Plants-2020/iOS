//
//  PlantDetailViewController.swift
//  WaterMyPlants
//
//  Created by Morgan Smith on 8/19/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit

class PlantDetailViewController: UIViewController {
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var plantSpeciesTextField: UITextField!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var h2oFrequencyTextField: UITextField!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    var plantDetailController: PlantDetailController?
    
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let nickname = nicknameTextField.text, let species = plantSpeciesTextField.text else {return}
        
        if let existingPlant = plant {
            plantDetailController?.update(nickname: nickname, species: species, h20Frequency: 0, plant: plant!)
        }
        
        else {
            let newPlant = Plant(id: 0, nickname: nickname, species: species, h20Frequency: 0, avatar: "")
            plantDetailController?.sendPlantToServer(plant: newPlant)
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }

        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        
       
    }
    
    
    func updateViews() {
        print("update views")
        guard isViewLoaded else {return}
        
        title = plant?.nickname ?? "Add New Plant"
        nicknameTextField.text = plant?.nickname ?? ""
        plantSpeciesTextField.text = plant?.species ?? ""
        
        if plant != nil {
            saveChangesButton.setTitle("Edit Plant", for: .normal)
        }
        else {
            saveChangesButton.setTitle("Add Plant", for: .normal)
        }
    }
}
