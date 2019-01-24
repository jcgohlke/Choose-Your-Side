///
///  RosterViewController.swift
///  MultipleDataSourceExample
///
///  Created by Ben Gohlke on 1/21/19.
///  Copyright © 2019 Ben Gohlke
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import UIKit

class RosterViewController: UIViewController, UITableViewDelegate
{
    // MARK: IBOutlets
    
    @IBOutlet private weak var heroesTableView: UITableView!
    @IBOutlet private weak var starkLogo: UIImageView!
    
    // MARK: Private Properties
    
    private var secondWindow: UIWindow?
    private var secondScreen: UIScreen?
    private var heroDetailVC: HeroDetailViewController?
    
    private let teamCap = CivilWarDataSource(for: "TeamCap")
    private let teamIronMan = CivilWarDataSource(for: "TeamIronMan")
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        heroesTableView.dataSource = teamCap
        title = "Roster"
        
        configureView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(externalScreenDisconnected), name: UIScreen.didDisconnectNotification, object: nil)
    }
    
    func configureView()
    {
        navigationController?.navigationBar.barTintColor = UIColor(hue: 359/360, saturation: 40/100, brightness: 10/100, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor(hue: 359/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        navigationController?.navigationBar.barStyle = .black
        
        starkLogo.image = UIImage(named: "stark-logo")?.withRenderingMode(.alwaysTemplate)
        starkLogo.tintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        heroDetailVC = nil
    }
    
    // MARK: - Actions
    
    @IBAction private func segmentedControlValueChanged(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            heroesTableView.dataSource = teamCap
        }
        else
        {
            heroesTableView.dataSource = teamIronMan
        }
        heroesTableView.reloadData()
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let ds = heroesTableView.dataSource as? CivilWarDataSource
        {
            if heroDetailVC == nil {
                heroDetailVC = storyboard?.instantiateViewController(withIdentifier: "HeroDetailView") as? HeroDetailViewController
            }
            
            guard let heroDetailVC = heroDetailVC else {
                assertionFailure("didSelectRow: Hero Detail VC should not be nil here")
                return
            }
            
            heroDetailVC.hero = ds.hero(at: indexPath.row)
            
            checkForSecondScreenAndReturnWindowIfPresent()
            
            if let secondWindow = secondWindow
            {
                if secondWindow.rootViewController != heroDetailVC
                {
                    secondWindow.rootViewController = heroDetailVC
                    secondWindow.isHidden = false
                } else {
                    heroDetailVC.configureView()
                }
            } else
            {
                navigationController?.pushViewController(heroDetailVC, animated: true)
            }
        }
    }
    
    // MARK: - Notification Handlers
    
    @objc func externalScreenDisconnected(notification: Notification)
    {
        secondWindow?.isHidden = true
        secondWindow = nil
        secondScreen = nil
        heroDetailVC = nil
    }
    
    // MARK: - Private Methods
    
    private func checkForSecondScreenAndReturnWindowIfPresent()
    {
        if secondScreen == nil, UIScreen.screens.count > 1
        {
            let secScreen = UIScreen.screens[1]
            secScreen.currentMode = secScreen.preferredMode
            secondScreen = secScreen
        }
        
        guard let secondScreen = secondScreen else { return }
        
        if secondWindow == nil
        {
            let bounds = secondScreen.bounds
            let secWindow = UIWindow(frame: bounds)
            secWindow.screen = secondScreen
            secondWindow = secWindow
        }
    }
}
