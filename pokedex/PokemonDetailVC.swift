//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Francisco Claret on 04/03/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var mySegmentedControll: UISegmentedControl!
    
    @IBOutlet weak var r1c1TitleLbl: UILabel!
    @IBOutlet weak var r2c1TitleLbl: UILabel!
    @IBOutlet weak var r3c1TitleLbl: UILabel!
    @IBOutlet weak var r1c2TitleLbl: UILabel!
    @IBOutlet weak var r2c2TitleLbl: UILabel!
    @IBOutlet weak var r3c2TitleLbl: UILabel!
    
    //INFO SEGMENT OUTLETS
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
    
    //MOVES SEGMENT OUTLETS
    
    
    
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
        let str = "Next evolution \(pokemon.evoTxt)"
        
            if pokemon.nextEvoLvl == "N/A" {
                evoTxtLbl.text = str
            
            } else {
                evoTxtLbl.text = str + " LVL:\(pokemon.nextEvoLvl)"
            }
        }
    }
    
    func updateMoves() {
        
        descLbl.text = pokemon.moveDesc
        
        typeLb.text = pokemon.moveName
        heightLbl.text = pokemon.learn_type
        
        defence.text = pokemon.accuracy
        pokedexId.text = pokemon.power
        baseAttackLbl.text = pokemon.pp
    }

    @IBAction func backBtnPressed(sender: AnyObject) {
    
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            
            r1c1TitleLbl.text = "Move:"
            r2c1TitleLbl.text = "Learn type:"
            r3c1TitleLbl.text = ""
            weightLbl.text = ""
            
            r1c2TitleLbl.text = "Accuracy:"
            r2c2TitleLbl.text = "Power:"
            r3c2TitleLbl.text = "PP:"
            
            pokemon.downloadMoves { DownloadComplete in
                self.updateMoves()
            }
            
        } else {
            
            r1c1TitleLbl.text = "Type:"
            r2c1TitleLbl.text = "Height:"
            r3c1TitleLbl.text = "Weight:"
            
            r1c2TitleLbl.text = "Defence:"
            r2c2TitleLbl.text = "Pokex Id:"
            r3c2TitleLbl.text = "Base Attack:"
            
            updateUI()
        }
    }
}
