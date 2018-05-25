//
//  NegativeBinomialDistributionGraphViewController.swift
//  ProbabilityProject1
//
//  Created by Азизбек Матчанов on 08/03/2018.
//  Copyright © 2018 Azizbek Matchanov. All rights reserved.
//

import UIKit
import Foundation
import iosMath
import PopupDialog
import ScrollableGraphView

class NegativeBinomialDistributionGraphViewController: UIViewController, ScrollableGraphViewDataSource {
    
    var numberOfDataItems = 200
    var lowerBound = 0
    var upperBound = 0
    lazy var probabilityPlotData: [Double] = [0.0]
    lazy var xAxisLabels: [String] = self.generateXAxisLabels()
    
    // Declaration of view, labels, textFields and Button; declaration comes one after another as in the application
    var graphView : ScrollableGraphView!
    let k1Label = MTMathUILabel(frame: CGRect(x: 30, y: 500, width: 50, height: 21))
    let k1TextField = UITextField(frame: CGRect(x: 80, y: 495, width: 90, height: 30))
    let k2Label = MTMathUILabel(frame: CGRect(x: 30, y: 550, width: 50, height: 21))
    let k2TextField = UITextField(frame: CGRect(x: 80, y: 545, width: 90, height: 30))
    let rLabel = MTMathUILabel(frame: CGRect(x: 210, y: 500, width: 50, height: 21))
    let rTextField = UITextField(frame: CGRect(x: 250, y: 495, width: 90, height: 30))
    let pLabel = MTMathUILabel(frame: CGRect(x: 210, y: 550, width: 50, height: 21))
    let pTextField = UITextField(frame: CGRect(x: 250, y: 545, width: 90, height: 30))
    let calculateProbabilityButton = UIButton(frame: CGRect(x: 15, y: 600, width: 170, height: 50))
    let resetButton = UIButton(frame: CGRect(x: 190, y: 600, width: 170, height: 50))
    // Prepare the popup assets
    let messageTitle = "ERROR"
    let message = "Something went wrong! Graph with probability -1 shows that error has occured. Remember that value of p is positive and less than 1. Also notice that k1 and k2 defines lower and higher bounds respectively and r is less than k1"
    // Create button
    let OKButton = DefaultButton(title: "OK") {
        print("You pressed ok button")
    }
    // end of declaration
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 240/255, alpha: 1.0)
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(NegativeBinomialDistributionGraphViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NegativeBinomialDistributionGraphViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        calculateProbabilityButton.isEnabled = false
        k1TextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        k2TextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        pTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        //setting labels texts and positioning them on the view
        
        k1Label.latex = "k_1 = "
        self.view.addSubview(k1Label)
        
        k1TextField.borderStyle = UITextBorderStyle.roundedRect
        k1TextField.autocorrectionType = UITextAutocorrectionType.no
        k1TextField.keyboardType = UIKeyboardType.numberPad
        k1TextField.returnKeyType = UIReturnKeyType.done
        k1TextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        self.view.addSubview(k1TextField)
        
        k2Label.latex = "k_2 = "
        self.view.addSubview(k2Label)
        
        k2TextField.borderStyle = UITextBorderStyle.roundedRect
        k2TextField.autocorrectionType = UITextAutocorrectionType.no
        k2TextField.keyboardType = UIKeyboardType.numberPad
        k2TextField.returnKeyType = UIReturnKeyType.done
        k2TextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        self.view.addSubview(k2TextField)
        
        rLabel.latex = "r = "
        self.view.addSubview(rLabel)
        
        rTextField.borderStyle = UITextBorderStyle.roundedRect
        rTextField.autocorrectionType = UITextAutocorrectionType.no
        rTextField.keyboardType = UIKeyboardType.numberPad
        rTextField.returnKeyType = UIReturnKeyType.done
        rTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        self.view.addSubview(rTextField)
        
        pLabel.latex = "p = "
        self.view.addSubview(pLabel)
        
        pTextField.borderStyle = UITextBorderStyle.roundedRect
        pTextField.autocorrectionType = UITextAutocorrectionType.no
        pTextField.keyboardType = UIKeyboardType.decimalPad
        pTextField.returnKeyType = UIReturnKeyType.done
        pTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        self.view.addSubview(pTextField)
        
        // button attributes
        calculateProbabilityButton.setTitle("Fill the values", for: .normal)
        calculateProbabilityButton.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.3)
        calculateProbabilityButton.addTarget(self, action: #selector(calculateProbabilityButtonAction), for: .touchUpInside)
        calculateProbabilityButton.layer.cornerRadius = 15
        calculateProbabilityButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        calculateProbabilityButton.layer.shadowRadius = 2
        calculateProbabilityButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        calculateProbabilityButton.layer.shadowOpacity = 0.5
        self.view.addSubview(calculateProbabilityButton)
        // button attributes
        resetButton.setTitle("Reset the values", for: .normal)
        resetButton.backgroundColor = UIColor(red: 212/255, green: 97/255, blue: 80/255, alpha: 1.0)
        resetButton.addTarget(self, action: #selector(resetButtonAction), for: .touchUpInside)
        resetButton.layer.cornerRadius = 15
        resetButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        resetButton.layer.shadowRadius = 2
        resetButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        resetButton.layer.shadowOpacity = 0.5
        self.view.addSubview(resetButton)
        
    }
    
    @objc func calculateProbabilityButtonAction(sender: UIButton!) {
        
        animateButton(sender: sender)
        probabilityPlotData = calculateNegativeProbabilityWith(pValue: pTextField, k1Value: k1TextField, k2Value: k2TextField, rValue: rTextField)
        numberOfDataItems = probabilityPlotData.count
        let graphView = ScrollableGraphView(frame: CGRect(x: 10, y: 80, width: 350, height: 400), dataSource: self)
        xAxisLabels = generateXAxisLabels()
        graphView.rangeMax = 1.0
        graphView.shouldAnimateOnStartup = true
        let probabilityMassFunctionGraph = BarPlot(identifier: "probabilityMassFunctionGraph")
        let referenceLines = ReferenceLines()
        graphView.addPlot(plot: probabilityMassFunctionGraph)
        graphView.addReferenceLines(referenceLines: referenceLines)
        self.view.addSubview(graphView)
    }
    
    @objc func resetButtonAction(sender: UIButton!) {
        animateButton(sender: sender)
        resetProbabilityTextFields()
        calculateProbabilityButton.isEnabled = false
        calculateProbabilityButton.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.3)
        calculateProbabilityButton.setTitle("Fill the values", for: .normal)
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let k1Text = k1TextField.text, !k1Text.isEmpty,
            let k2Text = k2TextField.text, !k2Text.isEmpty,
            let rText = rTextField.text, !rText.isEmpty,
            let pText = pTextField.text, !pText.isEmpty
            else {
                calculateProbabilityButton.isEnabled = false
                calculateProbabilityButton.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.3)
                calculateProbabilityButton.setTitle("Fill the values", for: .normal)
                return
        }
        calculateProbabilityButton.isEnabled = true
        calculateProbabilityButton.backgroundColor = UIColor(red: 97/255, green: 212/255, blue: 80/255, alpha: 1.0)
        calculateProbabilityButton.setTitle("Plot the graph", for: .normal)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func animateButton (sender: UIButton!) {
        UIButton.animate(withDuration: 0.1,
                         animations: {
                            sender.transform = CGAffineTransform(scaleX: 0.875, y: 0.86)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.1, animations: {
                                sender.transform = CGAffineTransform.identity
                            })
        })
    }

    func calculateNegativeProbabilityWith (pValue: UITextField, k1Value: UITextField, k2Value: UITextField, rValue: UITextField) -> [Double] {
        let testK1 = NumberFormatter().number(from: k1Value.text!)
        let testK2 = NumberFormatter().number(from: k2Value.text!)
        let testR = NumberFormatter().number(from: rValue.text!)
        let testP = NumberFormatter().number(from: pValue.text!)
        if let testP = testP, let testK1 = testK1, let testK2 = testK2, let testR = testR {
            let p = Double(truncating: testP)
            let k1 = Double(truncating: testK1)
            let k2 = Double(truncating: testK2)
            let r = Double(truncating: testR)
            if k1 > k2 || p >= 1.0 || r == 0 || k1 < r {
                popupError()
                return [-1.0]
            }
            else {
                lowerBound = Int(k1)
                upperBound = Int(k2)
                var index = k1
                var result: [Double] = []
                let q = 1 - p
                while index <= k2 {
                    let k = index
                    let power = k - r
                    let combination = combinations((k-1), choose: (r-1))
                    result.append(combination * (pow(q, power)) * (pow(p, r)))
                    index += 1.0
                }
                print("Probability is \(result)")
                return result
            }
        }
        else {
            popupError()
            return [-1.0]
        }
    }
    
    func factorial(_ n: Double) -> Double {
        var n = n
        var result = 1.0
        while n > 1.0 {
            result *= n
            n -= 1.0
        }
        return result
    }
    
    func permutations(_ n: Double, _ k: Double) -> Double {
        var n = n
        var answer = n
        var i = 1.0
        while i < k {
            n -= 1
            answer *= n
            i += 1.0
        }
        return answer
    }
    
    func combinations(_ n: Double, choose k: Double) -> Double {
        return permutations(n, k) / factorial(k)
    }
    
    func popupError () {
        // Create the dialog
        let popup = PopupDialog(title: messageTitle, message: message)
        popup.addButton(OKButton)
        self.present(popup, animated: true, completion: nil)
        //end of popup declaration
    }
    
    func resetProbabilityTextFields () {
        k1TextField.text = ""
        k2TextField.text = ""
        rTextField.text = ""
        pTextField.text = ""
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "probabilityMassFunctionGraph":
            return probabilityPlotData[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return xAxisLabels[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        return numberOfDataItems
    }
    
    func generateXAxisLabels() -> [String] {
        var labels = [String]()
        for index in lowerBound ... upperBound {
            labels.append("\(index)")
        }
        return labels
    }
    
}
