//
//  SuccessViewController.swift
//  CleanUp
//
//  Created by Сергей Киселев on 07.04.2025.
//

import UIKit

class SuccessViewController: UIViewController {
    var deletedCount: Int = 0
    private let mainImg = UIImageView()
    private let mainTitle = UILabel()
    private let photosImg = UIImageView()
    private let photosLabelMain = UILabel()
    private let photosLabelTxt = UILabel()
    private let timeImg = UIImageView()
    private let timeLabelMain = UILabel()
    private let timeLabelTxt = UILabel()
    
    private let labelTxt = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        let freedSpace = String(format: "%.1f", Double(deletedCount) * 0.5)

        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Great", for: .normal)
        button.layer.cornerRadius = 24
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(backToRoot), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        mainImg.image = UIImage(named: "congrat1")
        mainImg.translatesAutoresizingMaskIntoConstraints = false
        
        mainTitle.text = "Congratulations!"
        mainTitle.font = .boldSystemFont(ofSize: 36)
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        
        photosImg.image = UIImage(named: "congrat2")
        photosImg.translatesAutoresizingMaskIntoConstraints = false
        
        photosLabelMain.text = "You have deleted"
        photosLabelMain.translatesAutoresizingMaskIntoConstraints = false
        
        photosLabelTxt.text = "\(deletedCount) Photos (\(freedSpace) MB)"
        photosLabelTxt.translatesAutoresizingMaskIntoConstraints = false
        
        timeImg.image = UIImage(named: "congrat_time")
        timeImg.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabelMain.text = "Saved 10 Minutes"
        timeLabelMain.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabelTxt.text = "using Cleanup"
        timeLabelTxt.translatesAutoresizingMaskIntoConstraints = false
        
        labelTxt.text = "Review all your videos. Sort the by size or date. See the ones that occupy the most space."
        labelTxt.numberOfLines = 0
        labelTxt.font = .systemFont(ofSize: 16, weight: .light)
        labelTxt.textAlignment = .center
        labelTxt.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(photosImg)
        view.addSubview(photosLabelMain)
        view.addSubview(photosLabelTxt)
        view.addSubview(timeImg)
        view.addSubview(timeLabelMain)
        view.addSubview(timeLabelTxt)

        
        view.addSubview(mainImg)
        view.addSubview(mainTitle)
        view.addSubview(labelTxt)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            mainImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mainTitle.topAnchor.constraint(equalTo: mainImg.bottomAnchor, constant: 20),
            mainTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            photosImg.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 40),
            photosImg.bottomAnchor.constraint(equalTo: photosLabelTxt.bottomAnchor, constant: 0),
            photosImg.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -70),
            
            photosLabelMain.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 40),
            photosLabelMain.leftAnchor.constraint(equalTo: photosImg.rightAnchor, constant: 20),
            
            photosLabelTxt.topAnchor.constraint(equalTo: photosLabelMain.bottomAnchor, constant: 10),
            photosLabelTxt.leftAnchor.constraint(equalTo: photosImg.rightAnchor, constant: 20),
            
            timeImg.topAnchor.constraint(equalTo: photosLabelTxt.bottomAnchor, constant: 20),
            timeImg.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -70),
            timeImg.bottomAnchor.constraint(equalTo: timeLabelTxt.bottomAnchor, constant: 0),
            
            timeLabelMain.topAnchor.constraint(equalTo: photosLabelTxt.bottomAnchor, constant: 20),
            timeLabelMain.leftAnchor.constraint(equalTo: timeImg.rightAnchor, constant: 20),
            
            timeLabelTxt.topAnchor.constraint(equalTo: timeLabelMain.bottomAnchor, constant: 10),
            timeLabelTxt.leftAnchor.constraint(equalTo: timeImg.rightAnchor, constant: 20),
            
            labelTxt.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -30),
            labelTxt.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            labelTxt.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -120),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }

    @objc func backToRoot() {
        let vc = UINavigationController(rootViewController: SimilarPhotosViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
//        navigationController?.popToRootViewController(animated: true)
    }
}
