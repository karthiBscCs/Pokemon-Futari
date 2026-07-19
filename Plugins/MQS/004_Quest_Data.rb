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
	:Stage3 => "Deliver Food to Elders house",
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
    :Stage1 => "Ask villagers about festival plans",
    :Stage2 => "Report back to Elder",
    :Location1 => "Gracewood Village",
    :Location2 => "Elder's House",
    :QuestDescription => "The Elder's daughter has been very busy these last few days, so she wasn't able to ask around what everyone was planning on doing tomorrow. Ask around town and make a little list of what everyone plans on contributing.",
    :RewardString => "???"
  }
end
