//
//  ViewController.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 14/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class LogInViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var userTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var logInWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var loaderImageView: UIImageView!
    
    private enum Constants {
        static let pathCornerRadius: CGFloat = 8
    }
    
    private var animationFromHeader = true
    private let markerShapeLayer: CAShapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButton.layer.cornerRadius = 8
        loaderImageView.isHidden = true
        
        markerShapeLayer.strokeColor = UIColor.red.cgColor
        markerShapeLayer.fillColor = UIColor.clear.cgColor
        markerShapeLayer.lineWidth = 2.0
        markerShapeLayer.lineCap = .round
        view.layer.addSublayer(markerShapeLayer)
        
        view.layer.speed = 1
    }
    
    @IBAction func handleLogInTap(_ sender: UIButton) {
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        let markerPath = UIBezierPath()
        markerPath.move(to: CGPoint(x: passwordTextField.frame.minX, y: passwordTextField.frame.minY))
        markerPath.addLine(to: CGPoint(x: passwordTextField.frame.minX, y: sender.frame.maxY - Constants.pathCornerRadius))
        markerPath.addArc(withCenter: CGPoint(x: passwordTextField.frame.minX + Constants.pathCornerRadius,
                                              y: sender.frame.maxY - Constants.pathCornerRadius),
                          radius: Constants.pathCornerRadius,
                          startAngle: -.pi,
                          endAngle: .pi / 2,
                          clockwise: false)
        markerPath.addLine(to: CGPoint(x: sender.frame.midX, y: sender.frame.maxY))
        
        let lenght = passwordTextField.frame.height + 12.56 + sender.frame.maxY - passwordTextField.frame.maxY + sender.frame.midX - passwordTextField.frame.minX
        
        let startValue = passwordTextField.frame.height / lenght
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = startValue
        strokeEndAnimation.toValue = 1
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -0.5
        strokeStartAnimation.toValue = 1
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 0.3
        strokeAnimationGroup.animations = [strokeEndAnimation, strokeStartAnimation]
        strokeAnimationGroup.delegate = self
        strokeAnimationGroup.setValue("button", forKey: "name")
        markerShapeLayer.add(strokeAnimationGroup, forKey: nil)
        animationFromHeader = false
        markerShapeLayer.path = markerPath.cgPath
        
        setUpLoader()
        logInWidthConstraint.constant = 40
        UIView.animate(withDuration: 0.4, delay: 0.15, animations: {
            sender.setTitle("", for: .normal)
            self.loaderImageView.alpha = 1
            self.logInButton.backgroundColor = UIColor(red: 1, green: 0.42, blue: 0.24, alpha: 1)
            self.logInButton.layer.cornerRadius = 20
            self.view.layoutSubviews()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.stopLoader()
        }
    }
    
    func setUpLoader() {
        guard let image = UIImage(named: "loader") else { return }
        loaderImageView.image = image
        loaderImageView.tintColor = .white
        loaderImageView.isHidden = false
        loaderImageView.alpha = 0
        
        animateLoader()
    }
    
    func animateLoader() {
        if loaderImageView.layer.animation(forKey: "kSpinnerAnimation") == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0
            rotationAnimation.toValue = -Float.pi * 2
            rotationAnimation.duration = 1
            rotationAnimation.repeatCount = .infinity
            
            loaderImageView.layer.add(rotationAnimation, forKey: "kSpinnerAnimation")
        }
    }
    
    func stopLoaderAnimation() {
        guard loaderImageView.layer.animation(forKey: "kSpinnerAnimation") != nil else { return }
        loaderImageView.layer.removeAnimation(forKey: "kSpinnerAnimation")
    }
    
    func stopLoader() {
        UIView.animate(withDuration: 0.2, animations: {
            self.loaderImageView.alpha = 0
        }) { _ in
            self.stopLoaderAnimation()
            print("changeScreens")
        }
    }
    
    @IBAction func TextFieldEditBegun(_ sender: UITextField) {
        if animationFromHeader {
            let markerPath = UIBezierPath()
            markerPath.move(to: CGPoint(x: titleLabel.frame.maxX, y: titleLabel.frame.maxY))
            markerPath.addLine(to: CGPoint(x: sender.frame.minX + Constants.pathCornerRadius, y: titleLabel.frame.maxY))
            markerPath.addArc(withCenter: CGPoint(x: sender.frame.minX + Constants.pathCornerRadius,
                                                  y: titleLabel.frame.maxY + Constants.pathCornerRadius),
                              radius: Constants.pathCornerRadius,
                              startAngle: -.pi / 2,
                              endAngle: -.pi,
                              clockwise: false)
            markerPath.addLine(to: CGPoint(x: sender.frame.minX, y: sender.frame.maxY))
            
            let lenght = titleLabel.frame.maxX - sender.frame.minX - Constants.pathCornerRadius + 12.56 + sender.frame.maxY - titleLabel.frame.maxY - Constants.pathCornerRadius
            
            let startValue = titleLabel.frame.width / lenght
            let endValue = 1 - (sender.frame.height / lenght)
            let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
            strokeEndAnimation.fromValue = startValue
            strokeEndAnimation.toValue = 1.0
            let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
            strokeStartAnimation.fromValue = -0.5
            strokeStartAnimation.toValue = endValue
            let strokeAnimationGroup = CAAnimationGroup()
            strokeAnimationGroup.duration = 0.3
            strokeAnimationGroup.animations = [strokeEndAnimation, strokeStartAnimation]
            strokeAnimationGroup.delegate = self
            strokeAnimationGroup.setValue("textField", forKey: "name")
            strokeAnimationGroup.setValue(sender, forKey: "textField")
            markerShapeLayer.add(strokeAnimationGroup, forKey: "EnterAnimation")
            animationFromHeader = false
            markerShapeLayer.path = markerPath.cgPath
        } else {
            let markerPath = UIBezierPath()
            markerPath.move(to: CGPoint(x: sender.frame.minX, y: sender.frame.minY))
            markerPath.addLine(to: CGPoint(x: sender.frame.minX, y: sender.frame.maxY))
            animateStroke(to: markerPath)
            markerShapeLayer.path = markerPath.cgPath
        }
    }
    
    func animateStroke(to finalPath: UIBezierPath) {
        let strokeStartAnimation = CABasicAnimation(keyPath: "path")
        strokeStartAnimation.fromValue = markerShapeLayer.path
        strokeStartAnimation.toValue = finalPath.cgPath
        strokeStartAnimation.fillMode = .forwards
        strokeStartAnimation.duration = 0.2
        markerShapeLayer.add(strokeStartAnimation, forKey: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateEnterLine()
    }
}

private extension LogInViewController {
    func animateEnterLine() {
        let startingPoint = CGPoint(x: -10, y: titleLabel.frame.maxY)
        let endPoint = CGPoint(x: titleLabel.frame.maxX * 0.95, y: titleLabel.frame.maxY)
        
        let markerPath = UIBezierPath()
        markerPath.move(to: startingPoint)
        markerPath.addLine(to: endPoint)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 0.5
        strokeAnimationGroup.animations = [strokeEndAnimation]
        strokeAnimationGroup.delegate = self
        strokeAnimationGroup.setValue("initial", forKey: "name")
        markerShapeLayer.add(strokeAnimationGroup, forKey: "EnterAnimation")
        markerShapeLayer.path = markerPath.cgPath
    }
}

extension LogInViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: "name") as? String else {
            return
        }
        
        switch name {
        case "initial":
            let middlePoint = CGPoint(x: titleLabel.frame.minX, y: titleLabel.frame.maxY)
            let endPoint = CGPoint(x: titleLabel.frame.maxX, y: titleLabel.frame.maxY)
            let finalMarkerPath = UIBezierPath()
            finalMarkerPath.move(to: middlePoint)
            finalMarkerPath.addLine(to: endPoint)
            animateStroke(to: finalMarkerPath)
            markerShapeLayer.path = finalMarkerPath.cgPath
        case "textField":
            guard let textField = anim.value(forKey: "textField") as? UITextField else {
                return
            }
            let finalMarkerPath = UIBezierPath()
            finalMarkerPath.move(to: CGPoint(x: textField.frame.minX, y: textField.frame.minY))
            finalMarkerPath.addLine(to: CGPoint(x: textField.frame.minX, y: textField.frame.maxY))
            markerShapeLayer.path = finalMarkerPath.cgPath
        case "button":
            markerShapeLayer.removeFromSuperlayer()
        default:
            return
        }
    }
}
