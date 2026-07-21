module QuestModule
  
  # You don't actually need to add any information, but the respective fields in the UI will be blank or "???"
  # I included this here mostly as an example of what not to do, but also to show it's a thing that exists
  Quest0 = {
  
  }

  Quest1 = {
    :ID => "1",
    :Name => "Gather Seasonal Food and Cook",
    :QuestGiver => "Karen",
    :Stage1 => "Gather ingredients",
	:Stage2 => "Cook & Share a Meal",
	:Stage3 => "Deliver Food to Elder's house",
    :Location1 => "Gracewood Forest",
	:Location2 => "Home",
	:Location3 => "Freesia Town",
    :QuestDescription => "Gather 4 berries, 3 mushrooms, 2 honey and 3 firewoods.",
    :RewardString => "???"
  }
  Quest2 = {
    :ID => "2",
    :Name => "A Little List",
    :QuestGiver => "Elder",
    :Stage1 => "Ask the villagers about their festival plans.",
	:Stage2 => "Report back to Elder",
    :Location1 => "Gracewood Village",
	:Location2 => "Elder's House",
    :QuestDescription => "The Elder's daughter has been too busy to ask around town about tomorrow's plans. Ask the villagers what they intend to contribute and make a small list.",
    :RewardString => "???"
  }
  Quest3 = {
    :ID => "3",
    :Name => "Go to sleep",
    :QuestGiver => "Karen",
    :Stage1 => "Go home and take some rest",
	:Stage2 => "Festival day",
    :Location1 => "Home",
	:Location2 => "Gracewood Village",
    :QuestDescription => "It's almost night, and tomorrow is the festival. Head home and get some sleep.",
    :RewardString => "???"
  }
end
