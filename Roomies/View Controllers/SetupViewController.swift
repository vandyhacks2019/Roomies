//
//  SetupViewController.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit

class SetupViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!

    var pendingIndex: Int?
    var currentIndex: Int = 0
    var setupPageController: UIPageViewController?

    private lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "LivingSpaceLocation"),
            self.getViewController(withIdentifier: "InviteFriends")
        ]
    }()

    private func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Keaton", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }

    override func viewDidLoad() {
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = currentIndex

        self.pages.forEach { viewController in
            if let sharePage = viewController as? LivingSpaceSharePage {
                sharePage.setupViewController = self
            } else if let locationPage = viewController as? LivingSpaceLocationPage {
                locationPage.setupViewController = self
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedSetupPageController",
            let destination = segue.destination as? UIPageViewController,
            let firstPageController = self.pages.first {

            self.setupPageController = destination
            self.setupPageController?.delegate = self
            self.setupPageController?.setViewControllers([firstPageController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    public func setChosenAddress(_ chosenAddress: PhysicalAddress) {
        if let lastPageController = self.pages.last as? LivingSpaceSharePage {
            lastPageController.chosenAddress = chosenAddress
        }
    }

    public func goToNextPage() {
        if let lastPageController = self.pages.last {
            self.setupPageController?.setViewControllers([lastPageController], direction: .forward, animated: true, completion: { (didComplete) in
                    if (didComplete && self.currentIndex + 1 < self.pages.count) {
                        self.currentIndex = self.currentIndex + 1
                        self.pageControl.currentPage = self.currentIndex
                    }
                })
        }
    }

    public func goToPreviousPage() {
        if let firstPageController = self.pages.first {
            self.setupPageController?.setViewControllers([firstPageController], direction: .reverse, animated: true, completion: { (didComplete) in
                    if (didComplete && self.currentIndex - 1 >= 0) {
                        self.currentIndex = self.currentIndex - 1
                        self.pageControl.currentPage = self.currentIndex
                    }
                })
        }
    }
}

extension SetupViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.pages.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else { return self.pages.last }
        guard self.pages.count > previousIndex else { return nil }

        return self.pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.pages.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < self.pages.count else { return self.pages.first }
        guard self.pages.count > nextIndex else { return nil }

        return self.pages[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let pendingViewController = pendingViewControllers.first else { return }
        guard let viewControllerIndex = self.pages.firstIndex(of: pendingViewController) else { return }
        self.pendingIndex = viewControllerIndex
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let pendingIndex = self.pendingIndex, completed {
            self.currentIndex = pendingIndex
            pageControl.currentPage = self.currentIndex
        }
    }
}

