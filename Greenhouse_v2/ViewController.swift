//
//  ViewController.swift
//  Greenhouse_v2
//
//  Created by Tomás Veiga on 05/05/2023.
//

import UIKit
import SnapKit
import SwiftUI

class MyViewController: UIViewController {
    
    let greenhouseManager = GreenhouseDataManager()
    var greenhouse: GreenhouseData?
    var tempData: WholeVariableData?
    var humidityData: WholeVariableData?
    var lightData: WholeVariableData?
    var windowData: WholeVariableData?
    
    func viewDidLoad() async {
        super.viewDidLoad()
        
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     stackView.topAnchor.constraint(equalTo: view.topAnchor),
                                     stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                                    ])
        
        if let greenhouse = greenhouse {
            let greenhouseView = GreenhouseUIView(greenhouse: greenhouse, tempData: tempData!, humidityData: humidityData!, lightData: lightData!, windowData: windowData!)
            stackView.addArrangedSubview(greenhouseView)
        } else {
            let loadingView = LoadingUIView()
            stackView.addArrangedSubview(loadingView)
            do {
                try await greenhouseManager.fetchData()
                let greenhouse = greenhouseManager.getGreenhouseData()
                self.greenhouse = greenhouse
                let greenhouseView = GreenhouseUIView(greenhouse: greenhouse, tempData: tempData!, humidityData: humidityData!, lightData: lightData!, windowData: windowData!)
                DispatchQueue.main.async {
                    loadingView.removeFromSuperview()
                    stackView.addArrangedSubview(greenhouseView)
                }
            } catch {
                print("Error getting greenhouse: \(error)")
            }
        }
        
        view.backgroundColor = UIColor(hue: 0.6, saturation: 0.887, brightness: 0.557, alpha: 1.0)
        overrideUserInterfaceStyle = .dark
    }
    
    @objc func filterButtonTapped() {
        // 1.
        let filterVC = FilterViewController()
        filterVC.modalPresentationStyle = .custom
        filterVC.transitioningDelegate = self
        self.present(filterVC, animated: true, completion: nil)
    }
}


extension MyViewController: UIViewControllerTransitioningDelegate {
    // 2.
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        FilterPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
