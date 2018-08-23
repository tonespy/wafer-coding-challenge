//
//  CountryTableViewCell.swift
//  wafer-coding-challenge
//
//  Created by Abubakar Oladeji on 22/08/2018.
//  Copyright © 2018 Tonespy. All rights reserved.
//

import UIKit

protocol CountryCellProtocol {
    func currentPanningCell(cell: CountryTableViewCell)
    func deleteRow(atIndex indexPath: IndexPath)
}

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let actionView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let deletedBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "delete_icon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var indexPath: IndexPath!
    var leftConstraint: NSLayoutConstraint?
    var countryDelegate: CountryCellProtocol?
    var actualCenter = CGPoint()
    var actualFrame: CGRect = CGRect.zero
    lazy var frameWidth: CGFloat = {
        return frame.size.width
    }()
    
    // Country Model
    var country: Country? {
        didSet {
            if let country = country {
                viewModel = CountryTableViewViewModel(withCountry: country)
                viewModel?.setupModel()
            }
        }
    }
    
    // Cell ViewModel
    var viewModel: CountryTableViewViewModel? {
        didSet {
            setupViewModel()
        }
    }
    
    struct Constants {
        // This is the default maximun velocity of the pan gesture along the X-Axis
        static let MAX_POINT_PER_SEC: CGFloat = 1000
        // Default Anchor point
        static let DEFAULT_ANCHOR_POINT: CGFloat = 100
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        gestureRecognizer.minimumNumberOfTouches = 1
        gestureRecognizer.delegate = self
        mainContentView.addGestureRecognizer(gestureRecognizer)
        
        self.actualCenter = mainContentView.center
        self.actualFrame = mainContentView.frame
        
        self.addSubview(actionView)
        leftConstraint = actionView.leftAnchor.constraint(equalTo: leftAnchor, constant: frameWidth)
        leftConstraint?.isActive = true
        actionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        actionView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        actionView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        actionView.addSubview(deletedBtn)
        deletedBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        deletedBtn.heightAnchor.constraint(equalTo: actionView.heightAnchor).isActive = true
        deletedBtn.leftAnchor.constraint(equalTo: actionView.leftAnchor).isActive = true
        deletedBtn.centerYAnchor.constraint(equalTo: actionView.centerYAnchor).isActive = true
        deletedBtn.addTarget(self, action: #selector(deleteCountry(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let transition = panGesture.translation(in: superview!)
            if fabs(transition.x) > fabs(transition.y) {
                return true
            }
        }
        return false
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view)
        let velocity = sender.velocity(in: sender.view)
        
        if sender.state == .began {
            countryDelegate?.currentPanningCell(cell: self)
        }
        
        if sender.state == .changed {
            animatePan(x: (actualCenter.x + translation.x), y: actualCenter.y, constant: self.frameWidth + translation.x)
        }
        
        if sender.state == .ended {
            if translation.x <= 0 {
                let tranlationX = 0 - translation.x
                let velocityX = 0 - velocity.x
                
                // Setting 1000 is a fast velocity
                if velocityX >= Constants.MAX_POINT_PER_SEC {
                    animatePan(x: self.frameWidth, y: actualCenter.y, constant: 0)
                    countryDelegate?.deleteRow(atIndex: indexPath)
                    actionView.removeFromSuperview()
                } else {
                    if tranlationX == Constants.DEFAULT_ANCHOR_POINT {
                        animatePan(x: self.actualCenter.x, y: self.actualCenter.y, constant: self.frameWidth)
                    } else if tranlationX > Constants.DEFAULT_ANCHOR_POINT {
                        animatePan(x: (self.actualCenter.x - Constants.DEFAULT_ANCHOR_POINT), y: actualCenter.y, constant: (self.frameWidth - Constants.DEFAULT_ANCHOR_POINT))
                    } else if tranlationX < Constants.DEFAULT_ANCHOR_POINT {
                        animatePan(x: self.actualCenter.x, y: self.actualCenter.y, constant: self.frameWidth)
                    }
                }
            } else { animatePan(x: self.actualCenter.x, y: self.actualCenter.y, constant: self.frameWidth) }
        }
    }
    
    private func animatePan(x: CGFloat, y: CGFloat, constant: CGFloat) {
        mainContentView.center = CGPoint(x: x, y: y)
        self.leftConstraint?.isActive = false
        self.leftConstraint?.constant = constant
        self.leftConstraint?.isActive = true
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    func resetPan() {
        animatePan(x: self.actualCenter.x, y: self.actualCenter.y, constant: self.frameWidth)
    }
    
    @IBAction func deleteCountry(_ sender: UIButton) {
        animatePan(x: self.frameWidth, y: actualCenter.y, constant: 0)
        countryDelegate?.deleteRow(atIndex: indexPath)
    }

}
