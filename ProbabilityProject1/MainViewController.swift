//
//  MainViewController.swift
//  ProbabilityProject1
//
//  Created by Азизбек Матчанов on 07/03/2018.
//  Copyright © 2018 Azizbek Matchanov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let probabilityArray: NSArray = ["Geometric Distribution","Negative Binomial Distribution", "Negative Binomial Distribution Graph"]
    private var probabilityTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        probabilityTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        probabilityTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        probabilityTableView.dataSource = self
        probabilityTableView.delegate = self
        self.view.addSubview(probabilityTableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(probabilityArray[indexPath.row])")
        
        if (indexPath.row == 0) {
            let newViewController = GeometricProbabilityViewController()
            self.navigationController?.pushViewController(newViewController, animated: true)
           
        }
        else if (indexPath.row == 1){
            let newViewController = NegativeProbabilityViewController()
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        else {
            let newViewController = NegativeBinomialDistributionGraphViewController()
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return probabilityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(probabilityArray[indexPath.row])"
        return cell
    }
    
}

extension UIView {
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
