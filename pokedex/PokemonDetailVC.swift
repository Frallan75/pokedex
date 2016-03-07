//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Francisco Claret on 04/03/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var typeLb: UILabel!
    @IBOutlet weak var defence: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexId: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoTxtLbl: UILabel!
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name
        mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
        currentEvoImg.image = mainImg.image
        
        pokemon.downloadPokemonDetails { DownloadComplete in
            self.updateUI()
        }
        
    }
    
    func updateUI() {
        
        descLbl.text = pokemon.desc
        typeLb.text = pokemon.type
        defence.text = "\(pokemon.defense)"
        heightLbl.text = pokemon.height
        pokedexId.text = "\(pokemon.pokedexId)"
        weightLbl.text = pokemon.weight
        baseAttackLbl.text = "\(pokemon.baseAttack)"
        
        if pokemon.nextEvoID == "N/A" {
        
            nextEvoImg.hidden = true
            evoTxtLbl.text = "No evolutions available"
        
        } else {
        
        nextEvoImg.hidden = false
        nextEvoImg.image = UIImage(named: "\(pokemon.nextEvoID)")
        var str = "Next evolution \(pokemon.evoTxt)"
        
            if pokemon.nextEvoLvl == "N/A" {
                evoTxtLbl.text = str
            
            } else {
                evoTxtLbl.text = str + " LVL:\(pokemon.nextEvoLvl)"
            }
        }
    }

    @IBAction func backBtnPressed(sender: AnyObject) {
    
        dismissViewControllerAnimated(true, completion: nil)
    }
}
