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
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _desc: String!
    private var _type: String!
    private var _defense: Int!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: Int!
    private var _evoTxt: String!
    private var _nextEvoID: String!
    private var _nextEvoLvl: String!
    private var _pokemonUrl: String!
    
    //MOVES
    private var _moveDesc: String!
    private var _moveName: String!
    private var _learn_type: String!
    private var _accuracy: String!
    private var _power: String!
    private var _pp: String!
    
    
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
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            
            let result = response.result
            
            print(result.value!.description)
            
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
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    
                    if let type = types[0]["name"] {
                        self._type = type.capitalizedString
                        print(self._type)
                    }
        
                    if types.count > 1 {
                        
                        for var x = 1; x < types.count; x++ {
                            
                            if let type = types[x]["name"] {
                                self._type = "\(self._type)/\(type.capitalizedString)"
                            }
                        }
                    } else {
                        self._type = "N/A"
                    }
                
                    print(self._type)
                
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                
                    if let to = evolutions[0]["to"] as? String {
                        
                        if to.rangeOfString("mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                               
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvoID = num
                                
                            }
                            self._evoTxt = to.capitalizedString
                            
                            if let lvl = evolutions[0]["level"] as? Int {
                                self._nextEvoLvl = "\(lvl)"
                                
                            }
                        }
                    }
                } else {
                    self._evoTxt = "N/A"
                    print(self._evoTxt)
                }
                
                if let descTxts = dict["descriptions"] as? [Dictionary<String, AnyObject>] where descTxts.count > 0 {
                    
                    if let descUrlString = descTxts[0]["resource_uri"] {
                        
                        let descNSUrl = NSURL(string: "\(URL_BASE)\(descUrlString)")!
                        
                        Alamofire.request(.GET, descNSUrl).responseJSON { response in
                            
                            let result = response.result
                            print(result.value!.description)
                            
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
    
    func downloadMoves(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            
        let result = response.result
            
            if let dict = result.value! as? Dictionary<String, AnyObject> {
                
                if let moves = dict["moves"] as? [Dictionary<String, AnyObject>] where moves.count > 0 {
                    
                    if let learn_type = moves[0]["learn_type"] as? String {
                        self._learn_type = learn_type.capitalizedString
                    }
                    
                    if let moveName = moves[0]["name"] as? String {
                        self._moveName = moveName.capitalizedString
                    }
                    
                    if let moveUrl = moves[0]["resource_uri"] as? String {
                        print(moveUrl)
                        let url = NSURL(string: "\(URL_BASE)\(moveUrl)")!
                        
                        Alamofire.request(.GET, url).responseJSON { response in
                            print("in request")
                            if let dict = response.result.value! as? Dictionary<String, AnyObject> where dict.count >  0 {
                                print("in response")
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


