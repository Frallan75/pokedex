//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Francisco Claret on 04/03/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var detailLbl: UILabel!
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailLbl.text = pokemon.name
        
    }

}
