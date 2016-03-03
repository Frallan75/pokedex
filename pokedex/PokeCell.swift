//
//  PokeCell.swift
//  pokedex
//
//  Created by Francisco Claret on 03/03/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    func configureCell(pokemon: Pokemon) {
        
        self.pokemon = pokemon
        nameLbl.text = self.pokemon.name.capitalizedString
        thumImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
    
}
