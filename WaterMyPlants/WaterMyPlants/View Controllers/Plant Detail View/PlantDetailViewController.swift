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
    
    let networkController = Networking.sharedNetworkController
    
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }


    func updateViews() {
        print("update views")
        guard isViewLoaded else {return}

        title = plant?.nickName ?? "Add New Plant"
        nicknameTextField.text = plant?.nickName ?? ""
        plantSpeciesTextField.text = plant?.species ?? ""
        h2oFrequencyTextField.text = plant?.h2oFrequency ?? ""

        if plant != nil {
            saveChangesButton.setTitle("Edit Plant", for: .normal)
        }
        else {
            saveChangesButton.setTitle("Add Plant", for: .normal)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let nickName = nicknameTextField.text, let species = plantSpeciesTextField.text else {return}
        
        if let existingPlant = plant {
            networkController.updatePlantOnCD(with: existingPlant, nickName: nickName, species: species, h2oFrequency: h2oFrequencyTextField.text ?? "1")
            networkController.deletePlantFromServer(plant: existingPlant)
           networkController.sendPlantToServer(plant: existingPlant)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        } else {
            let newPlant = Plant(nickName: nickName, species: species, h2oFrequency: h2oFrequencyTextField.text ?? "1", userId: networkController.currentCDUser?.id ?? 1, image: "", dateLastWatered: "", notificationTime: "")
            networkController.sendPlantToServer(plant: newPlant)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }

        navigationController?.popViewController(animated: true)
    }

}
