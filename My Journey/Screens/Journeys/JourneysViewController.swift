//
//  JourneysViewController.swift
//  My Journey
//
//  Created by Robert Tanase on 28/08/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation
import UIKit

class JourneysViewController: UIViewController {
    
    @IBOutlet weak var journeysTableView: UITableView!

    var journeys = [Journey]()
    var provider = JourneyProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "JourneysTableViewHeaderView", bundle: nil)
        journeysTableView.register(nib, forHeaderFooterViewReuseIdentifier: "JourneysTableViewHeaderView")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        journeys = provider.getJourneys()
        journeysTableView.reloadData()
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension JourneysViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journeys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = journeysTableView.dequeueReusableCell(withIdentifier: "JourneyTableViewCell") as? JourneyTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(withJourney: journeys[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Journey", bundle: nil)
        guard let journeyViewController = storyboard.instantiateViewController(withIdentifier: "JourneyViewController") as? JourneyViewController else {
            print("Could not instantiate JourneyViewController")
            return
        }
        journeyViewController.configure(withJourney: journeys[indexPath.row])
        self.navigationController?.pushViewController(journeyViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JourneysTableViewHeaderView")
                as? JourneysTableViewHeaderView
            else {
                preconditionFailure("Could not find JourneysTableViewHeaderView")
        }
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
}
