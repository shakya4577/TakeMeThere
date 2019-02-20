//
//  ViewController.swift
//  myEyes
//
//  Created by Wilson Kardam on 18/02/19.
//  Copyright © 2019 Wilson Shakya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnLetsWalkClick(_ sender: Any)
    {
        performSegue(withIdentifier: "ToARViewController", sender: Data())
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MyEyesARViewController
        {
            let arVC = segue.destination as? MyEyesARViewController
            arVC?.destinationLat = 28.6825662
            arVC?.destinationLong = 77.2321066
        }
    }

}

