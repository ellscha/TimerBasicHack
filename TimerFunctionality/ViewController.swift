//
//  ViewController.swift
//  TimerFunctionality
//
//  Created by ELLI SCHARLIN on 2/18/20.
//  Copyright © 2020 ELLI SCHARLIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    var timeAmountTextField = UITextField()
    var countdownLabel = UILabel()
    var startButton = UIButton()
    var pauseButton = UIButton()
    var resetButton = UIButton()
    var countdownStart: Int = 0
    var timerIsRunning = false
    var timer = Timer()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        timeAmountTextField = setupTextField(x: 80.0, y: 360.0, width: 300.0, height:40.0)
        countdownLabel = setupLabel(x: 80.0, y: 100.0, width: 300.0, height: 80.0)
        startButton = setupButton(x: 80.0, y: 500.0, width: 300.0, height: 40.0)
        pauseButton = setupButton(x: 80.0, y: 600.0, width: 300.0, height: 40.0)
        resetButton = setupButton(x: 80.0, y: 700.0, width: 300.0, height: 40.0)
        
        startButton.setTitle("Start Timer", for: .normal)
        pauseButton.setTitle("Pause Timer", for: .normal)
        resetButton.setTitle("Reset Timer", for: .normal)
        timeAmountTextField.center = self.view.center
        startButton.center.x = self.view.center.x
        startButton.addTarget(self, action: #selector(goButtonAction), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonPressed), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)

        resetButton.isHidden = true
        pauseButton.isHidden = true

        self.view.addSubview(startButton)
        self.view.addSubview(pauseButton)
        self.view.addSubview(resetButton)
        self.view.addSubview(timeAmountTextField)
        self.view.addSubview(countdownLabel)

    }
    
    func setupLabel(x: Double, y: Double, width: Double, height: Double) -> UILabel {
           let label =  UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
           label.backgroundColor = .systemPink
           label.layer.cornerRadius = 5
        label.center.x = self.view.center.x
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .center
           return label
       }

    
    
    @objc func goButtonAction() {
        guard let timeAmount = timeAmountTextField.text else {
            return
        }
        
        if !timeAmount.isInt {
            let alert = UIAlertController(title:
                "Time input invalid.", message: "Please enter a whole number", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        } else {
            countdownStart = Int(timeAmountTextField.text!) ?? 0
            runTimer()
            timerIsRunning = true
            timeAmountTextField.isEnabled = false
            startButton.isHidden = true
            pauseButton.isHidden = false
            resetButton.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func pauseButtonPressed() {
        if timerIsRunning == true {
             timer.invalidate()
            pauseButton.setTitle("Resume Timer", for: .normal)
             timerIsRunning = false
        } else {
             runTimer()
            pauseButton.setTitle("Pause Timer", for: .normal)

            timerIsRunning = true
        }
        
    }
    @objc func resetButtonPressed() {
        timer.invalidate()
        countdownStart = Int(timeAmountTextField.text!) ?? 0
        countdownLabel.text = timeString(time: TimeInterval(countdownStart))
        resetButton.isHidden = true
        pauseButton.isHidden = true
        startButton.isHidden = false
        timeAmountTextField.isEnabled = true
        pauseButton.setTitle("Pause Timer", for: .normal)
        timerIsRunning = false

    }
    
    func timeString(time:TimeInterval) -> String {
    let hours = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    @objc func updateTimer() {
        if countdownStart < 1 {
             timer.invalidate()
            pauseButton.isHidden = true
             //Send alert to indicate "time's up!"
        } else {
        countdownStart -= 1     //This will decrement(count down)the seconds.
        countdownLabel.text = timeString(time: TimeInterval(countdownStart))
        }
    }
    
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    func setupTextField(x: Double, y: Double, width: Double, height: Double) -> UITextField {
           let textField =  UITextField(frame: CGRect(x: x, y: y, width: width, height: height))
           textField.delegate = self
           textField.returnKeyType = .done
           textField.backgroundColor = .lightGray
           return textField
       }
    
    func setupButton(x: Double, y: Double, width: Double, height: Double) -> UIButton {
           let button =  UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
           button.layer.cornerRadius = 5
           button.center.x = self.view.center.x
           button.backgroundColor = .lightGray
        button.layer.borderWidth = 1.0
        button.layer.borderColor = CGColor(srgbRed: 0.5, green: 0.3, blue: 0.9, alpha: 1.0)
        button.tintColor = .purple
           return button
       }
}


extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
    
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
}
