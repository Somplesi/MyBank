//
//  ViewController.swift
//  MyBank
//
//  Created by Rodolphe DUPUY on 10/09/2020.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var waitView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ajouter dans plist: Privacy - Face ID Usage Description
        NotificationCenter.default.addObserver(self, selector: #selector(hide), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(authWithBiometrics), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func hide() {
        waitView.isHidden = false
    }
    
    @objc func authWithBiometrics() {
        if !waitView.isHidden {
            let context = LAContext()
            let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
            let reason = "Accéder à mes comptes"
            var error: NSError?
            if context.canEvaluatePolicy(policy, error: &error) {
                context.evaluatePolicy(policy, localizedReason: reason) { (success, error) in
                    DispatchQueue.main.async {
                        if let e = error {
                            let controller = UIAlertController(title: "Erreur", message: e.localizedDescription, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                            controller.addAction(ok)
                            self.present(controller, animated: true, completion: nil)
                        }
                        self.waitView.isHidden = success
                    }
                }
            }
        }
    }

}
