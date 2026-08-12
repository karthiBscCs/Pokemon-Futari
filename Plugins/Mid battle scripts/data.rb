#DON'T DELETE THIS LINE
module DialogueModule


# Format to add new stuff here
# Name = data
#
# To set in a script command
# BattleScripting.setInScript("condition",:Name)
# The ":" is important

#  Joey_TurnStart0 = {"text"=>"Hello","bar"=>true}
#  BattleScripting.set("turnStart0",:Joey_TurnStart0)

                  
##############Custom#########################################################################################
##############General########################################################################################
  Init= Proc.new{|battle|
      battle.battlers[1].effects[PBEffects::BossProtect] = true
	  pbMessage("The opponent is immune to status moves and stat drop.")
      }
      
  Midlife= Proc.new{|battle|
      battle.pbAnimation(:HOWL,battle.battlers[1],battle.battlers[0])
      pbMessage(_INTL("{1} is starting to get mad!",battle.battlers[1].name))
      battle.battlers[0].pbResetStatStages
      battle.battlers[1].pbResetStatStages
      battle.battlers[1].pbRaiseStatStage(:ATTACK,1,battle.battlers[1])
      battle.battlers[1].pbRaiseStatStage(:SPECIAL_ATTACK,1,battle.battlers[1])
      }
  
  Quartlife=Proc.new{|battle|
      battle.pbAnimation(:HOWL,battle.battlers[1],battle.battlers[0])
      pbMessage(_INTL("{1} is in pain!",battle.battlers[1].name))
      battle.battlers[0].pbResetStatStages
      battle.battlers[1].pbResetStatStages
      battle.battlers[1].pbRaiseStatStage(:ATTACK,2,battle.battlers[1])
      battle.battlers[1].pbRaiseStatStage(:SPECIAL_ATTACK,2,battle.battlers[1])
      battle.battlers[0].pbLowerStatStage(:SPECIAL_ATTACK,2,battle.battlers[0])
      battle.battlers[0].pbLowerStatStage(:ATTACK,2,battle.battlers[0])
      }

  Enrage=Proc.new{|battle|
      battle.pbAnimation(:HOWL,battle.battlers[1],battle.battlers[0])
      pbMessage(_INTL("{1} rages!",battle.battlers[1].name))
      battle.battlers[0].pbResetStatStages
      battle.battlers[1].pbResetStatStages
      battle.battlers[1].pbRaiseStatStage(:SPECIAL_ATTACK,6,battle.battlers[1])
      battle.battlers[1].pbRaiseStatStage(:ATTACK,6,battle.battlers[1])
      battle.battlers[1].pbRaiseStatStage(:SPEED,6,battle.battlers[1])
      }
 
 ##############Futari#####
 AlmaTurn0 = {"text"=>"\\xn[Alma]\\rHmm, I wonder... Should I hold back, or can I cut loose just a little?","bar"=>true}
 TylerTurn0 = {"text"=>"\\xn[Tyler]\\b...please don't exploit my weaknesses. I worked hard for them...","bar"=>true}
 KarenTurn0 = {"text"=>"\\xn[Karen]Don't think I'll hold back just because you're my best friend!","bar"=>true}
##############AROMALADYTest########################################"
	Tform=Proc.new{|battle|
		battle.scene.appearBar
		battle.pbCommonAnimation("MegaEvolution",battle.battlers[1],nil)
		battle.battlers[1].pbChangeForm(1,"blablabla")
		battle.battlers[1].name="BIG BOY" #if you need to change their name, you can
		pbMessage("The boss reached their final form!")
		battle.scene.pbRefresh
		battle.scene.disappearBar
		}
	Tcall=Proc.new{|battle|
		battle.pbCallForHelp(battle.battlers[1])
		}
 ##############Woods#####		
        T1JinaJo= Proc.new{|battle|
          $PokemonTemp.nextturnmoves=[nil,nil,[2,3],[0,1],nil,nil,0] #sudo attacks buneary
        }
        JinaTurn0 = {"text"=>"\\xn[Jina]\\rJoe ! Get over here, I'll teach you some manners!","bar"=>true}
        JoAttacks0 = {"text"=>"\\xn[Joe]\\bWe'll see if you're still acting like the smartest after this, Jina ! Sudowoodo, use Ultra-Megalaser of the dead!","bar"=>true}
        
        T2JinaJo= Proc.new{|battle|
          $PokemonTemp.nextturnmoves=[nil,[0,3],[3,1],[0,1],nil,1] #budew attacks sudo or quag, sudo attacks budew
        }
        JinaAttacks1=Proc.new{|battle|
		battle.scene.appearBar
        battle.scene.pbShowOpponent(0,true)
		pbMessage("\\xn[Jina]\\rThis is my payback!")
        battle.scene.pbHideOpponent
        battle.scene.pbShowOpponent(1,true)
        pbMessage("\\xn[Joe]\\bWe should stop this Jina...!")
        battle.scene.pbHideOpponent
        pbMessage("\\xn[Jina]\\r...")
		battle.scene.disappearBar
		}
# DONT DELETE THIS END
end