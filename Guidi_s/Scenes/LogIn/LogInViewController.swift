//
//  ViewController.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 14/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class LogInViewController: UIViewController {

    @IBOutlet private weak var topImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var logInButton: UIButton!
    @IBOutlet private weak var userTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var logInWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var loaderImageView: UIImageView!
    
    private enum Constants {
        static let pathCornerRadius: CGFloat = 8
        static let quarterLenght: CGFloat = .pi * pathCornerRadius / 2
        static let buttonFinalCornerRadius: CGFloat = 20
        static let animationIdentifier = "kAnimationIdentifier"
        static let enteringAnimationDuration = 0.5
        static let yDiff: CGFloat = 40
        static let initialPizzaWidth: CGFloat = 128
    }
    
    private var animationFromHeader = true
    private let markerShapeLayer: CAShapeLayer = CAShapeLayer()
    
    var viewModel: LogInViewModel!
    
    //MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.onLogInSuccess = {
            self.stopLoader()
        }
        viewModel.onValidInputs = { [unowned self] (valid) in
            self.logInButton.isEnabled = valid
            UIView.animate(withDuration: 0.3) {
                self.logInButton.backgroundColor = valid ? .customYellow : .silver
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewModel.animated {
            initialAnimation()
        } else {
            topImage.alpha = 1
            animateEnterLine()
            animateLogInObjects()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    //MARK: IBActions
    
    @IBAction func handleLogInTap(_ sender: UIButton) {
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        
        animateLineForLogIn()
        setUpLoader()
        
        logInWidthConstraint.constant = 40
        UIView.animate(withDuration: 0.4, delay: 0.15, animations: {
            sender.setTitle("", for: .normal)
            self.loaderImageView.alpha = 1
            self.logInButton.backgroundColor = .customGreen
            self.logInButton.layer.cornerRadius = Constants.buttonFinalCornerRadius
            self.view.layoutSubviews()
        })
        
        viewModel.logIn()
    }
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        viewModel.validate(username: userTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    @IBAction func TextFieldEditBegun(_ sender: UITextField) {
        if animationFromHeader {
            animateLineFromHeader(to: sender)
        } else {
            animateLineFromTextField(to: sender)
        }
    }
}

//MARK: - Private Methods

private extension LogInViewController {
    
    //MARK: Initial UI Configuration
    
    func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        logInButton.layer.cornerRadius = Constants.pathCornerRadius
        logInButton.isEnabled = false
        loaderImageView.isHidden = true
        
        markerShapeLayer.strokeColor = UIColor.red.cgColor
        markerShapeLayer.fillColor = UIColor.clear.cgColor
        markerShapeLayer.lineWidth = 2.0
        markerShapeLayer.lineCap = .round
        view.layer.addSublayer(markerShapeLayer)
        
        titleLabel.alpha = 0
        userTextField.alpha = 0
        passwordTextField.alpha = 0
        logInButton.alpha = 0
        if viewModel.animated {
            topImage.alpha = 0
        }
    }
    
    //MARK: Enter Animations
    
    func initialAnimation() {
        let imageView = UIImageView.init(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: Constants.initialPizzaWidth,
                                                       height: Constants.initialPizzaWidth))
        imageView.image = UIImage(named: "pizza")
        imageView.center = view.center
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.7,
                       delay: 0.3,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       animations: { imageView.frame = self.topImage.frame },
                       completion: { _ in
                        self.topImage.alpha = 1
                        self.animateEnterLine()
                        imageView.removeFromSuperview()
        })
        
        animateLogInObjects(withDelay: 0.4)
    }
    
    func animateLogInObjects(withDelay delay: Double = 0) {
        animateY(view: titleLabel, delay: delay + 0.05, yDiff: Constants.yDiff)
        titleLabel.animateAlpha(withDelay: delay + 0.05, duration: Constants.enteringAnimationDuration)
        animateY(view: userTextField, delay: delay + 0.15, yDiff: Constants.yDiff)
        userTextField.animateAlpha(withDelay: delay + 0.15, duration: Constants.enteringAnimationDuration)
        animateY(view: passwordTextField, delay: delay + 0.25, yDiff: Constants.yDiff)
        passwordTextField.animateAlpha(withDelay: delay + 0.25, duration: Constants.enteringAnimationDuration)
        animateY(view: logInButton, delay: delay + 0.35, yDiff: Constants.yDiff)
        logInButton.animateAlpha(withDelay: delay + 0.35, duration: Constants.enteringAnimationDuration)
    }
    
    //MARK: Loader Configuration & Animations
    
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
        }
    }
    
    //MARK: Line Path Animations
    
    func animateEnterLine() {
        let startingPoint = CGPoint(x: -10, y: titleLabel.frame.maxY)
        let endPoint = CGPoint(x: titleLabel.frame.maxX * 0.95, y: titleLabel.frame.maxY)
        
        let markerPath = UIBezierPath()
        markerPath.move(to: startingPoint)
        markerPath.addLine(to: endPoint)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        strokeEndAnimation.duration = 0.4
        strokeEndAnimation.delegate = self
        strokeEndAnimation.setValue("initial", forKey: Constants.animationIdentifier)
        
        markerShapeLayer.add(strokeEndAnimation, forKey: "EnterAnimation")
        markerShapeLayer.path = markerPath.cgPath
    }
    
    func animateStroke(to finalPath: UIBezierPath) {
        let strokeStartAnimation = CABasicAnimation(keyPath: "path")
        strokeStartAnimation.fromValue = markerShapeLayer.path
        strokeStartAnimation.toValue = finalPath.cgPath
        strokeStartAnimation.fillMode = .forwards
        strokeStartAnimation.duration = 0.2
        markerShapeLayer.add(strokeStartAnimation, forKey: nil)
    }
    
    func animateLineFromHeader(to textField: UITextField) {
        let markerPath = UIBezierPath()
        markerPath.move(to: CGPoint(x: titleLabel.frame.maxX, y: titleLabel.frame.maxY))
        markerPath.addLine(to: CGPoint(x: textField.frame.minX + Constants.pathCornerRadius, y: titleLabel.frame.maxY))
        markerPath.addArc(withCenter: CGPoint(x: textField.frame.minX + Constants.pathCornerRadius,
                                              y: titleLabel.frame.maxY + Constants.pathCornerRadius),
                          radius: Constants.pathCornerRadius,
                          startAngle: -.pi / 2,
                          endAngle: -.pi,
                          clockwise: false)
        markerPath.addLine(to: CGPoint(x: textField.frame.minX, y: textField.frame.maxY))
        
        let lenght = titleLabel.frame.maxX - textField.frame.minX - Constants.pathCornerRadius + 12.56 + textField.frame.maxY - titleLabel.frame.maxY - Constants.pathCornerRadius
        
        let startValue = titleLabel.frame.width / lenght
        let endValue = 1 - (textField.frame.height / lenght)
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
        strokeAnimationGroup.setValue("textField", forKey: Constants.animationIdentifier)
        strokeAnimationGroup.setValue(textField, forKey: "textField")
        strokeAnimationGroup.fillMode = .forwards
        strokeAnimationGroup.isRemovedOnCompletion = false
        markerShapeLayer.add(strokeAnimationGroup, forKey: "EnterAnimation")
        animationFromHeader = false
        markerShapeLayer.path = markerPath.cgPath
    }
    
    func animateLineFromTextField(to textField: UITextField) {
        let markerPath = UIBezierPath()
        markerPath.move(to: CGPoint(x: textField.frame.minX, y: textField.frame.minY))
        markerPath.addLine(to: CGPoint(x: textField.frame.minX, y: textField.frame.maxY))
        animateStroke(to: markerPath)
        markerShapeLayer.path = markerPath.cgPath
    }
    
    func animateLineForLogIn() {
        let markerPath = UIBezierPath()
        markerPath.move(to: CGPoint(x: passwordTextField.frame.minX, y: passwordTextField.frame.minY))
        markerPath.addLine(to: CGPoint(x: passwordTextField.frame.minX, y: logInButton.frame.maxY - Constants.pathCornerRadius))
        markerPath.addArc(withCenter: CGPoint(x: passwordTextField.frame.minX + Constants.pathCornerRadius,
                                              y: logInButton.frame.maxY - Constants.pathCornerRadius),
                          radius: Constants.pathCornerRadius,
                          startAngle: -.pi,
                          endAngle: .pi / 2,
                          clockwise: false)
        markerPath.addLine(to: CGPoint(x: logInButton.frame.midX, y: logInButton.frame.maxY))
        
        let pathLenght = passwordTextField.frame.height +
            Constants.quarterLenght +
            logInButton.frame.maxY -
            passwordTextField.frame.maxY +
            logInButton.frame.midX -
            passwordTextField.frame.minX
        
        let startValue = passwordTextField.frame.height / pathLenght
        
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
        strokeAnimationGroup.setValue("button", forKey: Constants.animationIdentifier)
        strokeAnimationGroup.fillMode = .forwards
        strokeAnimationGroup.isRemovedOnCompletion = false
        
        markerShapeLayer.add(strokeAnimationGroup, forKey: nil)
        animationFromHeader = false
        markerShapeLayer.path = markerPath.cgPath
    }
}

extension LogInViewController {
    func animateY<T: UIView>(view: T, delay: Double, yDiff: CGFloat) {
        view.center.y += Constants.yDiff
        UIView.animate(withDuration: Constants.enteringAnimationDuration,
                       delay: delay,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.1,
                       animations: { view.center.y -= yDiff },
                       completion: nil)
    }
}

//MARK: - CAAnimationDelegate

extension LogInViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let identifier = anim.value(forKey: Constants.animationIdentifier) as? String else {
            return
        }
        markerShapeLayer.removeAllAnimations()
        switch identifier {
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
