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

class RosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    // MARK: IBOutlets
    
    @IBOutlet private weak var heroesTableView: UITableView!
    @IBOutlet private weak var starkLogo: UIImageView!
    
    // MARK: Private Properties
    
    private var heroes = [Hero]()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Roster"
        
        configureView()
        loadHeroes(from: "TeamCap")
        
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
    }
    
    // MARK: - Actions
    
    @IBAction private func segmentedControlValueChanged(_ sender: UISegmentedControl)
    {
        
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    // TODO: move to Roster VC
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return heroes.count
    }
    
    // TODO: move to Roster VC
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath as IndexPath) as! HeroTableViewCell
        
        let aHero = heroes[indexPath.row]
        cell.heroNameLabel.text = aHero.alias
        cell.powersLabel.text = aHero.powers
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let heroDetailViewController = storyboard?.instantiateViewController(withIdentifier: "HeroDetailView") as? HeroDetailViewController
            
        guard let heroDetailVC = heroDetailViewController else {
            assertionFailure("didSelectRow: Hero Detail VC should not be nil here")
            return
        }
            
        heroDetailVC.hero = heroes[indexPath.row]
        navigationController?.pushViewController(heroDetailVC, animated: true)
    }
    
    // MARK: - Notification Handlers
    
    @objc func externalScreenDisconnected(notification: Notification)
    {
        
    }
    
    // MARK: - Private Methods
    
    private func checkForSecondScreenAndReturnWindowIfPresent()
    {
        
    }
    
    private func loadHeroes(from team: String)
    {
        let filePath = URL(fileURLWithPath: Bundle.main.path(forResource: team, ofType: "json")!)
        if let dataFromFile = try? Data(contentsOf: filePath)
        {
            if let heroList = try? JSONDecoder().decode([Hero].self, from: dataFromFile)
            {
                heroes = heroList
                heroes.sort(by: { $0.alias < $1.alias })
            }
        }
    }
}
