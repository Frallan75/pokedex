//
//  Pokemon.swift
//  pokedex
//
//  Created by Francisco Claret on 03/03/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    //DESCRIPTION
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    fileprivate var _desc: String!
    fileprivate var _type: String!
    fileprivate var _defense: Int!
    fileprivate var _height: String!
    fileprivate var _weight: String!
    fileprivate var _baseAttack: Int!
    fileprivate var _evoTxt: String!
    fileprivate var _nextEvoID: String!
    fileprivate var _nextEvoLvl: String!
    fileprivate var _pokemonUrl: String!
    
    //MOVES
    fileprivate var _moveDesc: String!
    fileprivate var _moveName: String!
    fileprivate var _learn_type: String!
    fileprivate var _accuracy: String!
    fileprivate var _power: String!
    fileprivate var _pp: String!
    
    
    var name: String {
        get {
            if _name == nil {
                _name = "N/A"
            }
            return _name
        }
    }
    
    var pokedexId: Int {
        get {
            if _pokedexId == nil {
                _pokedexId = 0
            }
            return _pokedexId
        }
    }
    
    var desc: String {
        get {
            if _desc == nil {
                _desc = "N/A"
            }
            return _desc
        }
    }
    
    var type: String {
        get {
            if _type == nil {
                _type = "N/A"
            }
            return _type
        }
    }
    
    var defense: Int {
        get {
            if _defense == nil {
                _defense = 0
            }
            return _defense
        }
    }
    
    var height: String {
        get {
            if _height == nil {
                _height = "N/A"
            }
            return _height
        }
    }
    
    var weight: String {
        get {
            if _weight == nil {
                _weight = "N/A"
            }
            return _weight
        }
    }
    
    var baseAttack: Int {
        get {
            if _baseAttack == nil {
                _baseAttack = 0
            }
            return _baseAttack
        }
    }
    
    var evoTxt: String {
        get {
            if _evoTxt == nil {
                _evoTxt = "N/A"
            }
            return self._evoTxt
        }
    }
    
    var nextEvoID: String {
        if _nextEvoID == nil {
            _nextEvoID = "N/A"
        }
        return self._nextEvoID
    }
    
    var nextEvoLvl: String {
        if _nextEvoLvl == nil {
            _nextEvoLvl = "N/A"
        }
        return self._nextEvoLvl
    }
    
    //MOVES VAR
    
    var moveDesc: String {
        if _moveDesc == nil {
            _moveDesc = "No move description available"
        }
        return _moveDesc
    }
    
    var learn_type: String {
        if _learn_type == nil {
            _learn_type = "N/A"
        }
        return _learn_type
    }
    
    var moveName: String {
        if _moveName == nil {
            _moveName = "N/A"
        }
        return _moveName
    }
    
    var accuracy: String {
        if _accuracy == nil {
            _accuracy = "N/A"
        }
        return _accuracy
    }
    
    var power: String {
        if _power == nil {
            _power = "N/A"
        }
        return _power
    }
    
    var pp: String {
        if _pp == nil {
            _pp = "N/A"
        }
        return _pp
    }

    init(name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
        
    }
    
    func downloadPokemonDetails(_ completed: @escaping DownloadComplete) {
        
        let url = URL(string: _pokemonUrl)!
        
        Alamofire.request(url).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value! as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._baseAttack = attack
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = defense
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    
                    if let type = types[0]["name"] {
                        self._type = type.capitalized
                        print(self._type)
                    }
        
                    if types.count > 1 {
                        
                        for x in 1 ..< types.count {
                            
                            if let type = types[x]["name"] {
                                self._type = "\(self._type)/\(type.capitalized)"
                            }
                        }
                    } else {
                        self._type = "N/A"
                    }
                
                    print(self._type)
                
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                
                    if let to = evolutions[0]["to"] as? String {
                        
                        if to.range(of: "mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                               
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let num = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvoID = num
                                
                            }
                            self._evoTxt = to.capitalized
                            
                            if let lvl = evolutions[0]["level"] as? Int {
                                self._nextEvoLvl = "\(lvl)"
                                
                            }
                        }
                    }
                } else {
                    self._evoTxt = "N/A"
                    print(self._evoTxt)
                }
                
                if let descTxts = dict["descriptions"] as? [Dictionary<String, AnyObject>], descTxts.count > 0 {
                    
                    if let descUrlString = descTxts[0]["resource_uri"] {
                        
                        let descNSUrl = URL(string: "\(URL_BASE)\(descUrlString)")!
                        
                        Alamofire.request(descNSUrl).responseJSON { response in
                            
                            let result = response.result
                            
                            if let dict = result.value! as? Dictionary<String, AnyObject> {
                                
                                if let desc = dict["description"] as? String {
                                    self._desc = desc
                                    print(self._desc)
                                }
                            }
                            completed()
                        }
                    }
                } else {
                    self._desc = "N/A"
                }
            }
        }
    }
    
    func downloadMoves(_ completed: @escaping DownloadComplete) {
        
        let url = URL(string: _pokemonUrl)!
        
        Alamofire.request(url).responseJSON { response in
            
        let result = response.result
            
            if let dict = result.value! as? Dictionary<String, AnyObject> {
                
                if let moves = dict["moves"] as? [Dictionary<String, AnyObject>], moves.count > 0 {
                    
                    if let learn_type = moves[0]["learn_type"] as? String {
                        self._learn_type = learn_type.capitalized
                    }
                    
                    if let moveName = moves[0]["name"] as? String {
                        self._moveName = moveName.capitalized
                    }
                    
                    if let moveUrl = moves[0]["resource_uri"] as? String {
     
                        let url = URL(string: "\(URL_BASE)\(moveUrl)")!
                        
                        Alamofire.request(url).responseJSON { response in
            
                            if let dict = response.result.value! as? Dictionary<String, AnyObject>, dict.count >  0 {
                           
                                if let moveDesc = dict["description"] as? String {
                                    self._moveDesc = moveDesc
                                }
                                
                                if let accuracy = dict["accuracy"] as? Int {
                                    self._accuracy = "\(accuracy)"
                                }
                                
                                if let power = dict["power"] as? Int {
                                    self._power = "\(power)"
                                }
                                
                                if let pp = dict["pp"] as? Int {
                                    self._pp = "\(pp)"
                                }
                                completed()
                            }
                        }
                    }
                }
            }
        }
    }
}


