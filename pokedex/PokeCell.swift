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
    
    func configureCell(_ pokemonToConfigure: Pokemon) {
        
        pokemon = pokemonToConfigure
        nameLbl.text = pokemon.name.capitalized
        thumImg.image = UIImage(named: "\(pokemon.pokedexId)")
    
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
}
