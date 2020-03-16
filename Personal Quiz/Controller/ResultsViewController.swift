//
//  ResultsViewController.swift
//  Personal Quiz
//
//  Created by qwerty on 15.03.2020.
//  Copyright © 2020 Dmitry Shuvalov. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    //MARK: - IB Outlets
    @IBOutlet var resultAnswerLabel: UILabel!
    @IBOutlet var resultDescriptionLabel: UILabel!
    
    //MARK: - Puiblic properties
    var responses: [Answer]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        updateResults()
    }
 
    private func updateResults() {
        var frequencyOfAnimals: [AnimalType : Int] = [:]
        let animals = responses.map {$0.type}
        for animal in animals {
            frequencyOfAnimals[animal] = (frequencyOfAnimals[animal] ?? 0) + 1
        }
        let sortedFrequencyOfAnimals = frequencyOfAnimals.sorted {$0.value > $1.value}
        
        guard let mostFrequencyAnimal = sortedFrequencyOfAnimals.first?.key else { return }
        
        updateUI(with: mostFrequencyAnimal)
    }
    
    private func updateUI(with animal: AnimalType) {
        resultAnswerLabel.text = "Вы - \(animal.rawValue)"
        resultDescriptionLabel.text = animal.definition
    }
}
