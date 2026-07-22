ItemHandlers::UseOnPokemonMaximum.add(:HPSOUP, proc { |item, pkmn|
  next pbMaxUsesOfEVRaisingItem(:HP, 252, pkmn, Settings::NO_VITAMIN_EV_CAP)
})

ItemHandlers::UseOnPokemon.add(:HPSOUP, proc { |item, qty, pkmn, scene|
  next pbUseEVRaisingItem(:HP, 252, qty, pkmn, "vitamin", scene, Settings::NO_VITAMIN_EV_CAP)
})

ItemHandlers::UseOnPokemonMaximum.add(:PROTEINSOUP, proc { |item, pkmn|
  next pbMaxUsesOfEVRaisingItem(:ATTACK, 252, pkmn, Settings::NO_VITAMIN_EV_CAP)
})

ItemHandlers::UseOnPokemon.add(:PROTEINSOUP, proc { |item, qty, pkmn, scene|
  next pbUseEVRaisingItem(:ATTACK, 252, qty, pkmn, "vitamin", scene, Settings::NO_VITAMIN_EV_CAP)
})

ItemHandlers::UseOnPokemonMaximum.add(:IRONSOUP, proc { |item, pkmn|
  next pbMaxUsesOfEVRaisingItem(:DEFENSE, 252, pkmn, Settings::NO_VITAMIN_EV_CAP)
})

ItemHandlers::UseOnPokemon.add(:IRONSOUP, proc { |item, qty, pkmn, scene|
  next pbUseEVRaisingItem(:DEFENSE, 252, qty, pkmn, "vitamin", scene, Settings::NO_VITAMIN_EV_CAP)
})

ItemHandlers::UseOnPokemonMaximum.add(:CALCIUMSOUP, proc { |item, pkmn|
  next pbMaxUsesOfEVRaisingItem(:SPECIAL_ATTACK, 252, pkmn, Settings::NO_VITAMIN_EV_CAP)
})

ItemHandlers::UseOnPokemon.add(:CALCIUMSOUP, proc { |item, qty, pkmn, scene|
  next pbUseEVRaisingItem(:SPECIAL_ATTACK, 252, qty, pkmn, "vitamin", scene, Settings::NO_VITAMIN_EV_CAP)
})

ItemHandlers::UseOnPokemonMaximum.add(:ZINCSOUP, proc { |item, pkmn|
  next pbMaxUsesOfEVRaisingItem(:SPECIAL_DEFENSE, 252, pkmn, Settings::NO_VITAMIN_EV_CAP)
})

ItemHandlers::UseOnPokemon.add(:ZINCSOUP, proc { |item, qty, pkmn, scene|
  next pbUseEVRaisingItem(:SPECIAL_DEFENSE, 252, qty, pkmn, "vitamin", scene, Settings::NO_VITAMIN_EV_CAP)
})

ItemHandlers::UseOnPokemonMaximum.add(:CARBOSSOUP, proc { |item, pkmn|
  next pbMaxUsesOfEVRaisingItem(:SPEED, 252, pkmn, Settings::NO_VITAMIN_EV_CAP)
})

ItemHandlers::UseOnPokemon.add(:CARBOSSOUP, proc { |item, qty, pkmn, scene|
  next pbUseEVRaisingItem(:SPEED, 252, qty, pkmn, "vitamin", scene, Settings::NO_VITAMIN_EV_CAP)
})


ItemHandlers::UseOnPokemon.copy(:FRESHSTARTMOCHI, :BLANDSOUP)

