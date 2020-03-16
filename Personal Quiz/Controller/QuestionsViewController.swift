//
//  QuestionsViewController.swift
//  Personal Quiz
//
//  Created by qwerty on 15.03.2020.
//  Copyright © 2020 Dmitry Shuvalov. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {

    
    //MARK: - IB Outlets
    
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
   
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet var rangedSlider: UISlider!
    
    @IBOutlet var questionProgressView: UIProgressView!
    
    //MARK: - Private Properties
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var answerChoseen: [Answer] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
    }
        
    //MARK: - IBActions
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        let currentAnswers =  questions[questionIndex].answers
        guard let currentIndex = singleButtons.firstIndex(of: sender) else {return}
        let currentAnswer = currentAnswers[currentIndex]
        answerChoseen.append(currentAnswer)
        
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {answerChoseen.append(answer)}
        }
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let currentAnswers =  questions[questionIndex].answers
        let currentAnswerIndex = Int(round(rangedSlider.value * Float((currentAnswers.count - 1))))
        let currentAnswer = currentAnswers[currentAnswerIndex]
        answerChoseen.append(currentAnswer)
        
        nextQuestion()
    }
    
    
    //MARK: - Private methods
    
    //Update user interface
    private func updateUI() {
        //Hide everthing
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        
        //Get current question
        let currentQuestion = questions[questionIndex]
        
        //Set current question for  question label
        questionLabel.text = currentQuestion.text
        
       
        // Calculate progress for questionProgressView
        let totalProgress = Float(questionIndex )/Float(questions.count)
        
        //Set progress view
        questionProgressView.setProgress(totalProgress, animated: true)
        
        // Set Navigation title
        title = "Вопрос №\(questionIndex + 1) из \(questions.count)"
        
        // Set current answers from current questions array
        let currentAnswers = currentQuestion.answers
        
        //Show correct stackview corresponding to question type
        switch currentQuestion.type {
        case .single:
            updateSingleStackView(using: currentAnswers)
        case .multiple:
            updateMultipleStackView(using: currentAnswers)
        case .ranged:
             updateRangedStackView(using: currentAnswers)
        }
        
    }
    
    /// Setup single stack view
    /// - Parameter answers: - array with answers
    ///Description of method
    private func updateSingleStackView(using answers: [Answer]) {
       //Show single stack view
        singleStackView.isHidden = false
        
        //Set text for question buttons
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.text, for: .normal)
        }
         
    }
    
    /// Setup multiple stack view
    /// - Parameter answers: - array with answers
    private func updateMultipleStackView(using answers: [Answer]) {
       //Show single stack view
        multipleStackView.isHidden = false
        
        //Set text for question labels
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.text
        }
        
        //Switch off swithes
        for multipleSwitch in multipleSwitches {
            multipleSwitch.isOn = false
        }
    }

    /// Setup ranged stack view
    /// - Parameter answers: - array with answers
    private func updateRangedStackView(using answers: [Answer]) {
       //Show single stack view
        rangedStackView.isHidden = false
        
        //Set text for range labels
        rangedLabels.first?.text = answers.first?.text
        rangedLabels.last?.text = answers.last?.text
    }
    
    //MARK: - Navigation
    private func nextQuestion() {
       // Show the next question or go to the next screen
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "resultSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Prepare resultViewController
        guard segue.identifier == "resultSegue" else { return }
        
        let resultVC = segue.destination as! ResultsViewController
        resultVC.responses = answerChoseen
        
    }
}
