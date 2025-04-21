//
//  SplashViewController.swift
//  CleanUp
//
//  Created by Сергей Киселев on 21.04.2025.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    private var animationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        animationView = LottieAnimationView(name: "loader_round")
        animationView?.frame = view.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .playOnce
        animationView?.animationSpeed = 1.0
        view.addSubview(animationView!)

        animationView?.play { [weak self] finished in
            guard finished else { return }
            self?.goToMainScreen()
        }
    }

    private func goToMainScreen() {
        let mainVC = SimilarPhotosViewController()
        let navVC = UINavigationController(rootViewController: mainVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
}
