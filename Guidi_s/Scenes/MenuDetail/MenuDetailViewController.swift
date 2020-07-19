//
//  MenuDetailViewController.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 16/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class MenuDetailViewController: UIViewController {
    
    @IBOutlet private(set) weak var imageHeader: UIImageView!
    @IBOutlet private(set) weak var headerBlurView: UIVisualEffectView!
    @IBOutlet private(set) weak var detailTableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var headerTitle: UILabel!
    @IBOutlet private weak var dismissButton: UIButton!
    
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var headerTitleCenterConstraint: NSLayoutConstraint!
    
    private enum Constants {
        static let headerHeight: CGFloat = 200
        static let iPhoneHasTopNotch = UIDevice.current.hasNotch
        static let initialOffset: CGFloat = iPhoneHasTopNotch ? 44 : 20
        static let navBarHeightSize: CGFloat = iPhoneHasTopNotch ? 100 : 76
        static let margin = headerHeight - navBarHeightSize
    }
    
    var viewModel: MenuDetailViewModel!
    
    //MARK: ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        headerTitle.text = viewModel.title
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.headerTitle.alpha = 1
            self.dismissButton.alpha = 1
        })
    }
    
    //MARK: IBActions
    
    @IBAction func dismiss(_ sender: UIButton) {
        viewModel.interactor?.shouldFinish = true
        viewModel.transition?.finalFrame = headerView.frame
        
        UIView.animate(withDuration: 0.15, animations: {
            self.headerBlurView.alpha = 0
            self.headerTitle.alpha = 0
            sender.alpha = 0
        }) { _ in
            self.viewModel.handleDismissTap()
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension MenuDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.foodToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.foodToDisplay[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let roundedOffset = (scrollView.contentOffset.y).rounded()
        let offset = roundedOffset + Constants.headerHeight + Constants.initialOffset
        updateHeader(offset: offset)
    }
}

//MARK: - Private Methods

private extension MenuDetailViewController {
    func configureUI() {
        imageHeader.image = UIImage(named: viewModel.selectedFoodCategory.imageName)
        headerBlurView.alpha = 0.25
        headerTitle.alpha = 0
        dismissButton.alpha = 0
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        headerView.addGestureRecognizer(pan)
    }
    
    func configureTableView() {
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.contentInset = UIEdgeInsets(top: Constants.headerHeight, left: 0, bottom: 40, right: 0)
        detailTableView.register(UINib(nibName: "DetailTableViewCell", bundle: Bundle.main),
                                 forCellReuseIdentifier: "DetailTableViewCell")
    }
    
    @objc
    func didPan(_ recognizer: UIPanGestureRecognizer) {
        let threshold: CGFloat = 0.4
        let translation = recognizer.translation(in: headerView)
        let verticalMovement = translation.y / (Constants.headerHeight * 2.5)
        let downwardMovement = max(verticalMovement, 0)
        let progress = min(downwardMovement, 0.99)

        guard let interactor = viewModel.interactor else { return }
        headerTitle.alpha = 0.5 - progress
        dismissButton.alpha = 0.5 - progress
        switch recognizer.state {
        case .began:
            interactor.hasStarted = true
            viewModel.transition?.finalFrame = headerView.frame
            viewModel.handleDismissTap()
        case .changed:
            interactor.update(progress)
            interactor.shouldFinish = progress > threshold
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
        default:
            break
        }
    }
    
    //MARK: Header Animation
    
    func updateHeader(offset: CGFloat) {
        let currentSize = Constants.headerHeight - offset
        let minSize = Constants.navBarHeightSize
        headerHeightConstraint.constant = (currentSize > minSize) ? currentSize : minSize
        updateHeaderTitle(offset: offset)
        setBlurAlpha()
    }
    
    func updateHeaderTitle(offset: CGFloat) {
        let coefficient = max(0, (Constants.headerHeight - headerHeightConstraint.constant) / Constants.margin)
        let scaleDiff = 0.5 * coefficient
        let scale = 1 - scaleDiff
        headerTitle.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        let maxLeft = UIScreen.main.bounds.width / 2 - headerTitle.bounds.width / 2 - 20
        let positionDiff = maxLeft *  (1 - coefficient)
        headerTitleCenterConstraint.constant = -positionDiff
        
    }
    
    func setBlurAlpha() {
        let alpha = (Constants.headerHeight - headerHeightConstraint.constant) / Constants.margin
        switch alpha {
        case 0...0.25:
            headerBlurView.alpha = 0.25
        case ..<0:
            headerBlurView.alpha = 0.25 + alpha
        default:
            headerBlurView.alpha = alpha
        }
    }
}
