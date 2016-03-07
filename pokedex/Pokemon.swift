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
    

    init(name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
        
    }
    
    func downloadPokemonDetails(completed: () -> ()) {
        
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
                    print(types.count)
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
                            print(self._evoTxt)
                            print(self._nextEvoID)
                            print(self._nextEvoLvl)
                            
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
}

