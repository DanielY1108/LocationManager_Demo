//
//  ViewController.swift
//  LocationManager_Demo
//
//  Created by JINSEOK on 2023/05/11.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var button: UIButton!
    
    var locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
    }
    
    func setupButton() {
        var config = UIButton.Configuration.filled()
        config.title = "스타트"
        button = UIButton(configuration: config)
        button.frame = CGRect(x: 150, y: 400, width: 100, height: 60)
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
    }
    
    @objc func buttonHandler(_ sender: UIButton) {
        locationManager.fetchLocation { location, error in
            print(location)
        }
    }
}
