class TournamentTrainers
 def get_trainer(param,trainer_data,poke_max = nil)
    begin
      ret = choose_party(trainer_data.party,param,poke_max)
      return ret
    rescue
      puts "Argument Error : the right arguments were not specified in 'TournamentSelection'"
      puts "Skipping the 'get_trainer' method..."
    end
 end

def choose_party(party,param,poke_max)
  if param == "ALMA"      #you can copy/paste this an only modify numbers
    party.each do |pkmn|
      pkmn.types.each do |type|
        rand = 1 if type == :FLYING
      end
    end

    party.each do |pkmn|    
      if pkmn == :SMOLIV
        if rand == 1
          rand = 2 
        else
          rand = 0
        end
        break
      end
    end

    teams = {
        "team0" => [2,1,0], #make a team with 3rd, 2nd and 1st pkmn of the original team. Number of index are number of pokemon in team
        "team1" => [3,2,0],
        "team2" => [1,3,0]
    }

    rand = rand(0..2) if !rand
    new_team = []
    teams["team#{rand}"].each do |slot|
      new_team.push(party[slot])
    end
    new_team.each { |pkmn| pkmn.calc_stats }
    return new_team
  elsif param == "TYLER"
    party.each do |pkmn| 
      pkmn.types.each do |type|
        rand = 0 if type == :GRASS
      end
    end
    party.each do |pkmn| 
      pkmn.types.each do |type|
        if type == :FLYING
          if rand == 0
            rand(0..1)
          else
            rand = 1
          end
        end
      end
    end
    teams = {
        "team0" => [2,1,0],
        "team1" => [2,3,0],
        "team2" => [1,3,0]
    }
    
    rand = rand(0..2) if !rand
    new_team = []
    teams["team#{rand}"].each do |slot|
      new_team.push(party[slot])
    end
    new_team.each { |pkmn| pkmn.calc_stats }
    return new_team
  elsif param == "ASTER"
    party.each do |pkmn|    
      if pkmn == :TOEDSCOOL
        rand = rand(0..1)
      end
    end

    teams = {
        "team0" => [3,4,0],
        "team1" => [2,3,0],
        "team2" => [1,2,0],
        "team3" => [1,4,0]
    }
    
    rand = rand(0..3) if !rand
    new_team = []
    teams["team#{rand}"].each do |slot|
      new_team.push(party[slot])
    end
    new_team.each { |pkmn| pkmn.calc_stats }
    return new_team
  elsif param == "FLEUR"
    party.each do |pkmn|
      pkmn.types.each do |type|
        rand = rand(0..1) if type == :POISON
      end
    end

    teams = {
        "team0" => [4,3,0],
        "team1" => [2,1,0],
        "team2" => [1,3,0],
        "team3" => [4,2,0]
    }
    
    rand = rand(0..3) if !rand
    new_team = []
    teams["team#{rand}"].each do |slot|
      new_team.push(party[slot])
    end
    new_team.each { |pkmn| pkmn.calc_stats }
    return new_team
  elsif param == "HARCHIBALD"

    teams = {
        "team0" => [2,4,0],
        "team1" => [1,2,0],
        "team2" => [3,1,0],
        "team3" => [4,1,0]
    }
    
    rand = rand(0..3) if !rand
    new_team = []
    teams["team#{rand}"].each do |slot|
      new_team.push(party[slot])
    end
    new_team.each { |pkmn| pkmn.calc_stats }
    return new_team
  elsif param == "JUNE"
    party.each do |pkmn|
      pkmn.types.each do |type|
        rand = rand(0..1) if type == :ROCK
      end
    end

    teams = {
        "team0" => [1,3,0],
        "team1" => [4,3,0],
        "team2" => [2,4,0],
        "team3" => [1,2,0]
    }
    
    rand = rand(0..3) if !rand
    new_team = []
    teams["team#{rand}"].each do |slot|
      new_team.push(party[slot])
    end
    new_team.each { |pkmn| pkmn.calc_stats }
    return new_team
  elsif param == "GAEUL"

    teams = {
        "team0" => [5,1,0],
        "team1" => [4,1,0],
        "team2" => [3,1,0],
        "team3" => [4,2,1],
        "team4" => [4,3,1],
        "team5" => [0,5,1]
    }
    
    rand = rand(0..5) if !rand
    new_team = []
    teams["team#{rand}"].each do |slot|
      new_team.push(party[slot])
    end
    new_team.each { |pkmn| pkmn.calc_stats }
    return new_team
   elsif param == "KAREN"

    teams = {
        "team0" => [2,1,0],
        "team1" => [4,3,0],
        "team2" => [1,5,0],
        "team3" => [3,2,0],
        "team4" => [0,4,5]
    }
    
    rand = rand(0..4) if !rand
    new_team = []
    teams["team#{rand}"].each do |slot|
      new_team.push(party[slot])
    end
    new_team.each { |pkmn| pkmn.calc_stats }
    return new_team
  else
    party.shuffle!
    party.length.times do
      party.pop if party.length > poke_max
    end
    party.each { |pkmn| pkmn.calc_stats }
    return party
  end
end


end