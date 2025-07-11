//
//  ViewController.swift
//  EggTimer
//
//  Created by Евгений Васильев on 10.07.2025.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    lazy var eggStackViewWidth = view.frame.width - 50
    let softTime = 5
    let mediumTime = 8
    let hardTime = 12
    let eggTime = ["Soft" : 3, "Medium": 4, "Hard": 7]
    var timer: Timer?
    var currentCounter = 0
    var totalTime = 0
    var player: AVAudioPlayer?
    enum Constants {
        
    }
    
    //MARK: - Create UI
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "How do you like youe eggs"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    let softEggButton : UIButton = {
        let button = UIButton()
        button.setTitle("Soft", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        button.setBackgroundImage(UIImage(named: "soft_egg"), for: .normal)
        button.addTarget(self, action: #selector(hardnessSelected), for: .touchUpInside)
        return button
    }()
    
    let mediumEggButton : UIButton = {
        let button = UIButton()
        button.setTitle("Medium", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        button.setBackgroundImage(UIImage(named: "medium_egg"), for: .normal)
        button.addTarget(self, action: #selector(hardnessSelected), for: .touchUpInside)
        return button
    }()
    
    let hardEggButton : UIButton = {
        let button = UIButton()
        button.setTitle("Hard", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        button.setBackgroundImage(UIImage(named: "hard_egg"), for: .normal)
        button.addTarget(self, action: #selector(hardnessSelected), for: .touchUpInside)
        return button
    }()
    
    let eggsStackView : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 10
        return view
    }()
    
    lazy var progressBar : UIProgressView = {
        let view = UIProgressView()
        view.progressTintColor = .systemYellow
        view.trackTintColor = .systemGray
        view.progress = 0.0
        return view
    }()
    
    //MARK: - Action Func
    
    @objc func hardnessSelected(sender: UIButton) {
        timer?.invalidate()
        progressBar.progress = 0.0
        titleLabel.text = "How do you like youe eggs"
        if let hardness = sender.currentTitle, let seconds = eggTime[hardness] {
            currentCounter = seconds
            totalTime = eggTime[hardness]!
            startTimer()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateCounter),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func updateCounter() {
        if currentCounter > 0 {
            currentCounter -= 1
            let progress = Float(totalTime - currentCounter) / Float(totalTime)
            progressBar.progress = progress
        } else {
            timer?.invalidate()
            titleLabel.text = "time finished"
            playSound()
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemCyan
        view.addSubview(titleLabel)
        view.addSubview(eggsStackView)
        eggsStackView.addArrangedSubview(softEggButton)
        eggsStackView.addArrangedSubview(mediumEggButton)
        eggsStackView.addArrangedSubview(hardEggButton)
        view.addSubview(progressBar)
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        eggsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eggsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            eggsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eggsStackView.widthAnchor.constraint(equalToConstant: eggStackViewWidth),
            eggsStackView.heightAnchor.constraint(equalToConstant: eggStackViewWidth/2.5)
        ])
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

