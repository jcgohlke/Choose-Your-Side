///
///  CivialWarDataSource.swift
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

import Foundation
import UIKit

final class CivilWarDataSource : NSObject, UITableViewDataSource
{
    // MARK: - Private Properties
    private var heroes = [Hero]()
    
    // MARK: - Initializers
    
    init?(for teamName: String?)
    {
        super.init()
        guard let team = teamName else { return }
        loadHeroes(from: team)
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath as IndexPath) as! HeroTableViewCell
        
        let aHero = heroes[indexPath.row]
        cell.heroNameLabel.text = aHero.alias
        cell.powersLabel.text = aHero.powers
        
        return cell
    }
    
    // MARK: - Internal Accessors
    
    func hero(at index: Int) -> Hero
    {
        return heroes[index]
    }
    
    // MARK: - Private
    
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
