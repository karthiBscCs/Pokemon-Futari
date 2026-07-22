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
  if param == "EXEMPLE"      #you can copy/paste this an only modify numbers
    party.each do |pkmn|            #a custom condition you can delete
      pkmn.types.each do |type|
        rand = 1 if type == :FLYING
      end
    end

    party.each do |pkmn|            #a custom condition you can delete
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
        "team2" => [1,3,0],
    }

    rand = rand(0..2) if !rand
    new_team = []
    teams["team#{rand}"].each do |slot|
      new_team.push(party[slot])
    end
    new_team.each { |pkmn| pkmn.calc_stats }
    return new_team
  elsif param == "EXEMPLE1"
    #do your thing here
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