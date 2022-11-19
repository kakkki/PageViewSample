//
//  PageViewSampleViewController.swift
//  PageViewSampleViewController
//
//  Created by Atsuki Kakehi on 2022/11/19.
//

import UIKit

class PageViewSampleViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    private var pageView: UIPageViewController!

    private var tabContents: [String: UIViewController] = [:]
    private let tabs: [String] = ["Monday", "Tuseday", "Wednesday", "Thursday"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func configure() {
        
        tabContents = [
            "Monday": makeViewController(className: "MondayViewController", for: MondayViewController.self),
            "Tuseday": makeViewController(className: "TusedayViewController", for: TusedayViewController.self),
            "Wednesday": makeViewController(className: "WednesdayViewController", for: WednesdayViewController.self),
            "Thursday": makeViewController(className: "ThursdayViewController", for: ThursdayViewController.self)
        ]

        print("debug0000 tabs.indices : \(tabs.indices)")

        print("debug0000 tabContents : \(tabContents)")

        configurePageView()
    }
}

extension PageViewSampleViewController {
    func configurePageView() {
        let pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
//        pageView.delegate = self
        pageView.dataSource = self
        addChild(pageView)
        pageView.view.frame = containerView.bounds
        containerView.addSubview(pageView.view)
        pageView.didMove(toParent: self)

//        let pageViewScrollView = pageView.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView
//        pageViewScrollView?.delegate = self
        
        /// controllers[0]! だとコントローラー切り替えられなかった
        pageView.setViewControllers([tabContents["Monday"]!], direction: .forward, animated: true)

    }
}

// MARK: makeViewController
extension PageViewSampleViewController {
    func makeViewController(className: String, for aClass: AnyClass) -> UIViewController {
        let storyboard = UIStoryboard(name: className, bundle: Bundle(for: aClass))
        let vc = storyboard.instantiateViewController(withIdentifier: className)
        return vc
    }
}

// MARK: - Tab
extension PageViewSampleViewController {
    private func tab(for viewController: UIViewController) -> String? {
        return tabContents.first(where: { $0.value == viewController })?.key
    }

    private func tabKey(from standardTabKey: String, position: Int) -> String? {
        guard let standardTabIndex = tabs.firstIndex(of: standardTabKey) else { return nil }

        let tabIndex = standardTabIndex + position
        print("debug0000 standardTabIndex + position : \(tabIndex)")
        
        return tabs.indices.contains(tabIndex) ? tabs[tabIndex] : nil
    }

    private func destinationVc(from standardVc: UIViewController, position: Int, logDescription: String) -> UIViewController? {
        // 現在表示してるViewControllerに対応するキー名を取得
        guard let standardTabKey = tab(for: standardVc) else { return nil }

        if let destinationTabKey = tabKey(from: standardTabKey, position: position) {
            print("debug0000 in \(logDescription) destinationVc not nil : \(destinationTabKey)")
            return tabContents[destinationTabKey]
        } else {
            print("debug0000 in \(logDescription) destinationVc nillllll")
            return nil
        }
    }

    private func move(to tab: String, direction: UIPageViewController.NavigationDirection, animated: Bool) {
        guard let viewForTab = tabContents[tab], let tabIndex = tabs.firstIndex(of: tab) else { return }

        pageView.setViewControllers([viewForTab], direction: direction, animated: animated)

//        tabMenuView.selectedIndex = tabIndex
    }
}

// MARK: - UIPageViewControllerDataSource
/**
 viewControllerは最初に表示してるViewControllerが表示される
 */
extension PageViewSampleViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        let destinationVc = destinationVc(from: viewController, position: -1, logDescription: "before")
        
        switch destinationVc {
        case let monday as MondayViewController:
            print("debug0000 before MondayViewController : \(monday.description)")
        case let tuseday as TusedayViewController:
            print("debug0000 before TusedayViewController : \(tuseday.description)")
        case let wednesday as WednesdayViewController:
            print("debug0000 before WednesdayViewController : \(wednesday.description)")
        case let thursday as ThursdayViewController:
            print("debug0000 before ThursdayViewController: \(thursday.description)")
        case nil:
            print("debug0000 before nil")
        default:
            print("debug0000 before default")
        }

        /// これをちゃんと対象のViewController返さないとダメっぽい
        /// Thursdayを固定で返すと、最初の一巡ではなんかいい感じに動くが、そのあとThursdayしか表示されなくなった
//        return makeViewController(className: "ThursdayViewController", for: ThursdayViewController.self)
        return destinationVc
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let destinationVc = destinationVc(from: viewController, position: +1, logDescription: "after")

        switch destinationVc {
        case let monday as MondayViewController:
            print("debug0000 after MondayViewController")
        case let tuseday as TusedayViewController:
            print("debug0000 after TusedayViewController")
        case let wednesday as WednesdayViewController:
            print("debug0000 after WednesdayViewController")
        case let thursday as ThursdayViewController:
            print("debug0000 after ThursdayViewController")
        case nil:
            print("debug0000 after nil")
        default:
            print("debug0000 after default")
        }
        
        return destinationVc
    }
}
