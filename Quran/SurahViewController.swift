//
//  SurahViewController.swift
//  Quran
//
//  Created by Mostafa Saleh on 11/17/19.
//

import Foundation

class SurahViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    var surah: MainSura!
    var nextSurah: MainSura!
    var isOpenedWithBookmark = false

    private var previousViewController: SinglePageViewController? {
        didSet {
            previousViewController?.loadViewIfNeeded()
        }
    }

    private var nextViewController: SinglePageViewController? {
        didSet {
            nextViewController?.loadViewIfNeeded()
        }
    }

    private lazy var currentPageNumber = surah.startPage
    private var surahNumber: Int!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        if isOpenedWithBookmark {
            if let data = UserDefaults.standard.data(forKey: AppDelegate.KEY_BOOKMARK_SURAH), let saved = NSKeyedUnarchiver.unarchiveObject(with: data) as? MainSura {
                surah = saved
                currentPageNumber = UserDefaults.standard.integer(forKey: AppDelegate.KEY_BOOKMARK_PAGE)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
        surahNumber = Int(surah.index) ?? 1
        setViewControllers([viewController(for: currentPageNumber)!], direction: .forward, animated: false, completion: nil)
        previousViewController = viewController(for: currentPageNumber + 1)
        nextViewController = viewController(for: currentPageNumber - 1)
        title = surah.titleAr
    }

    // MARK: Private functions

    private func viewController(for pageNumber: Int) -> SinglePageViewController? {
        guard (surah.startPage ... surah.endPage).contains(pageNumber) else { return nil }
        let viewController = storyboard!.instantiateViewController(withIdentifier: "SinglePageViewController") as! SinglePageViewController
        viewController.pageNumber = pageNumber
        viewController.surah = surah
        viewController.isOpenedWithBookmark = isOpenedWithBookmark
        isOpenedWithBookmark = false
        return viewController
    }

    // MARK: UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? SinglePageViewController, viewController.pageNumber < surah.endPage else { return nil }
        currentPageNumber += 1
        nextViewController = viewController
        return previousViewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? SinglePageViewController, viewController.pageNumber > surah.startPage else { return nil }
        currentPageNumber -= 1
        previousViewController = viewController
        return nextViewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if previousViewController?.pageNumber != currentPageNumber + 1 {
                previousViewController = viewController(for: currentPageNumber + 1)
            }
            if nextViewController?.pageNumber != currentPageNumber - 1 {
                nextViewController = viewController(for: currentPageNumber - 1)
            }
        }
    }
}
