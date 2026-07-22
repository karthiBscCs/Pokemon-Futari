module BattleCreationHelperMethods
  module_function

  # Skip battle if the player has no able Pokémon, or if holding Ctrl in Debug mode
  def skip_battle?
    return true if $player.able_pokemon_count == 0
    return true if $DEBUG && Input.press?(Input::CTRL)
    return false
  end

  def skip_battle(outcome_variable, trainer_battle = false)
    if $PokemonGlobal.tournamentSelection == true       #tournament selection plugin
      $player.party = $player.party + $PokemonGlobal.notSelectedParty
      $PokemonGlobal.tournamentSelection = false
    end
    pbMessage(_INTL("SKIPPING BATTLE...")) if !trainer_battle && $player.pokemon_count > 0
    pbMessage(_INTL("SKIPPING BATTLE...")) if trainer_battle && $DEBUG
    pbMessage(_INTL("AFTER WINNING...")) if trainer_battle && $player.able_pokemon_count > 0
    $game_temp.clear_battle_rules
    if $game_temp.memorized_bgm && $game_system.is_a?(Game_System)
      $game_system.bgm_pause
      $game_system.bgm_position = $game_temp.memorized_bgm_position
      $game_system.bgm_resume($game_temp.memorized_bgm)
    end
    $game_temp.memorized_bgm            = nil
    $game_temp.memorized_bgm_position   = 0
    $PokemonGlobal.nextBattleBGM        = nil
    $PokemonGlobal.nextBattleVictoryBGM = nil
    $PokemonGlobal.nextBattleCaptureME  = nil
    $PokemonGlobal.nextBattleBack       = nil
    $PokemonEncounters.reset_step_count
    outcome = 1   # Win
    outcome = 0 if trainer_battle && $player.able_pokemon_count == 0   # Undecided
    pbSet(outcome_variable, outcome)
    return outcome
  end
end