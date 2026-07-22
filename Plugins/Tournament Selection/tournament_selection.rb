=begin
--------------------------------------------------------
Tournament Selection by Neiro (for summer game jam 2026)
--------------------------------------------------------
  • Exemples of commands in an Event script command
______________________________________________________
• case 1 : I just want a team selection for the player
------------------------------------------------------
  TournamentSelection.new(                                   
  3,                            | arg 1 |         => pokemon team length,
  :TWINS,"Lea&Lisa"             | args 2, 3 |     => Trainer type, Name of trainer
  )
  ...
  TrainerBattle.start(:TWINS,"Lea&Lisa",1)       => overworld script event command, you may do an another trainer with the right amount of pokemon
    
______________________________________________________
• case 2 : I want a team selection for the player AND for the opponent
------------------------------------------------------
  selection = TournamentSelection.new(            => 'selection =' is mandatory if you want to have a random team, if you don't you can erase it                                       
  3,                            | arg 1 |         => pokemon team length,
  :TWINS,"Lea&Lisa"             | args 2, 3 |     => Trainer type, Name of trainer
  )
  TrainerBattle.start(selection.oppo_team)       => overworld script event command, those arguments are for a random team.

  WARNING : if you use global variable '@selection' and not 'selection', be sure to get : '@selection = nil' after the battle because your save will be corrupted by the uncleared Viewport of this scipt

_____________________________________________________
• case 3 : I want a team selection for the player AND a CUSTOM team for the opponent - different arguments are shown only for exemple
------------------------------------------------------

  TournamentSelection.new(
  4,                            | arg 1 |         => pokemon team length, 
  :POKEMONTRAINER_May,"May",3,  | args 2, 3, 4 |  => Trainer type, Name of trainer, version of trainer
  false,                        | arg 5 |         => hide opponent's items
  true,                         | arg 6 |         => starts immediatly the battle you don't have to TrainerBattle.start, 
  "EXEMPLE"                     | arg 7 |         => name of the variable you have maked in 'tournament_trainers', it choose a team for opponent
  )

_____________________________________________________

=end

class PokemonGlobalMetadata; attr_accessor :notSelectedParty, :tournamentSelection; end

class TournamentSelection

  attr_reader :oppo_team

  def initialize(poke_max, trainer_type_0,trainer_name_0,trainer_ver_0 = 0, show_items = true, battle_start = false, param = nil)
    if poke_max < 7 || poke_max > 0 || poke_max.is_a?(Integer)
      @poke_max = poke_max
    else
      puts "Specify an integer between 1 and 6 !"
      puts "TournamentSelection blocked"
      return
    end
    @show_items = show_items
    @trainer_0 = [trainer_type_0,trainer_name_0,trainer_ver_0]

    opp_trainer = pbLoadTrainer(trainer_type_0, trainer_name_0, trainer_ver_0)
    team = TournamentTrainers.new.get_trainer(
      param,
      opp_trainer,
      poke_max
    )
    opp_trainer.party = team
    @oppo_team = opp_trainer
      
    @viewport_foreground = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport_foreground.z = 99999
    @viewport_foreground.tone = Tone.new(0,0,0)

    fade_in
    draw_img
    main_loop
    TrainerBattle.start(@oppo_team) if battle_start == true
    pbBGMFade(2.0)
    end_fade

  end

  def draw_img
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99998
    @sprites = {}
    @textsprites = {}
    @sprites["textsprites1"] = Sprite.new(@viewport)
    @sprites["textsprites1"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["textsprites1"].z = 6
    @sprites["textsprites2"] = Sprite.new(@viewport)
    @sprites["textsprites2"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["textsprites2"].z = 6
    @sprites["textsprites3"] = Sprite.new(@viewport)
    @sprites["textsprites3"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["textsprites3"].z = 6
    @sprites["textsprites4"] = Sprite.new(@viewport)
    @sprites["textsprites4"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["textsprites4"].z = 6
    @sprites["textsprites5"] = Sprite.new(@viewport)
    @sprites["textsprites5"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["textsprites5"].z = 6
    @sprites["textsprites5"].visible = false
    @sprites["ball_bar"] = Sprite.new(@viewport)
    @sprites["ball_bar"].bitmap = Bitmap.new("Graphics/UI/Tournament Selection/ball_bar")
    @sprites["ball_bar"].x = @sprites["ball_bar"].bitmap.width / 2
    @sprites["ball_bar"].y = 29 + @sprites["ball_bar"].bitmap.height / 2
    @sprites["ball_bar"].z = 1
    @sprites["ball_bar"].ox = @sprites["ball_bar"].bitmap.width / 2
    @sprites["ball_bar"].oy = @sprites["ball_bar"].bitmap.height / 2
    @sprites["ball_bar"].visible = false
    @sprites["top_bar"] = Sprite.new(@viewport)
    @sprites["top_bar"].bitmap = Bitmap.new("Graphics/UI/Tournament Selection/top_bar")
    @sprites["top_bar"].y = 7
    @sprites["top_bar"].z = 1
    draw_party("player")
    draw_party("opponent")
    draw_animation("bg","Graphics/UI/Tournament Selection/bg",0)
    draw_animation("particles","Graphics/UI/Tournament Selection/particles",6)
    draw_balls
    textpos4 = [["Please choose #{@poke_max} POKÉMON.", Graphics.width / 2, 11, :center, Color.new(252, 252, 252),nil]]
    textsprites4 = @sprites["textsprites4"].bitmap
    pbSetSystemFont(textsprites4)
    MessageConfig.pbSetSmallFont(textsprites4)
    pbDrawTextPositions(textsprites4, textpos4)
  end

=begin
@sprites z :
  6 - [front particles],
  5 - [text],
  4 - [nums],
  3 - [balls, trainers, pokeicons],
  2 - [ball_slots,items],
  1 - [poke_bars,ball_bar,top_bar],
  0 - [background]
=end

  def draw_balls
    x_ball = 191
    x_ball_opp = 306
    @poke_max.times do |i|
      @sprites["ball#{i}"] = Sprite.new(@viewport)
      @sprites["ball#{i}"].bitmap = Bitmap.new("Graphics/UI/Tournament Selection/ball")
      @sprites["ball#{i}"].x = x_ball + @sprites["ball#{i}"].bitmap.width / 2
      @sprites["ball#{i}"].y = 39 + @sprites["ball#{i}"].bitmap.height / 2
      @sprites["ball#{i}"].z = 3
      @sprites["ball#{i}"].visible = false
      @sprites["ball#{i}"].ox = @sprites["ball#{i}"].bitmap.width / 2
      @sprites["ball#{i}"].oy = @sprites["ball#{i}"].bitmap.height / 2
      @sprites["ball_slot#{i}"] = Sprite.new(@viewport)
      @sprites["ball_slot#{i}"].bitmap = Bitmap.new("Graphics/UI/Tournament Selection/ball_slot")
      @sprites["ball_slot#{i}"].x = x_ball
      @sprites["ball_slot#{i}"].y = 39
      @sprites["ball_slot#{i}"].z = 2
      #-----------------------------------------------
      @sprites["ball_opp#{i}"] = Sprite.new(@viewport)
      @sprites["ball_opp#{i}"].bitmap = Bitmap.new("Graphics/UI/Tournament Selection/ball")
      @sprites["ball_opp#{i}"].x = x_ball_opp + @sprites["ball_opp#{i}"].bitmap.width / 2
      @sprites["ball_opp#{i}"].y = 39 + @sprites["ball_opp#{i}"].bitmap.height / 2
      @sprites["ball_opp#{i}"].z = 3
      @sprites["ball_opp#{i}"].visible = false
      @sprites["ball_opp#{i}"].ox = @sprites["ball_opp#{i}"].bitmap.width / 2
      @sprites["ball_opp#{i}"].oy = @sprites["ball_opp#{i}"].bitmap.height / 2
      @sprites["ball_opp_slot#{i}"] = Sprite.new(@viewport)
      @sprites["ball_opp_slot#{i}"].bitmap = Bitmap.new("Graphics/UI/Tournament Selection/ball_slot")
      @sprites["ball_opp_slot#{i}"].x = x_ball_opp
      @sprites["ball_opp_slot#{i}"].y = 39
      @sprites["ball_opp_slot#{i}"].z = 2
      x_ball -= 17
      x_ball_opp += 17
    end
  end
  
  def draw_party(side)
    textpos1 = []
    textpos2 = []
    y_nums = 88
    base = Color.new(252, 252, 252)
    shadow = Color.new(176, 176, 176)
    if side == "player"
      trainer = $player
      x_poke_bar = 0
      y_poke_bar = 75
      x_poke_icon = 172
      y_poke_icon = 90
      x_poke_txt = 8
      x_item = 132
      x_gender = 36
      textpos2.push([trainer.name, 61, 40, :left, base, nil])
    elsif side == "opponent"
      trainer = pbLoadTrainer(@trainer_0[0], @trainer_0[1], @trainer_0[2])
      x_poke_bar = Graphics.width - 206
      y_poke_bar = 75
      x_poke_icon = Graphics.width - 172
      y_poke_icon = 90
      x_poke_txt = Graphics.width - 138
      x_item = Graphics.width - 20
      x_gender = Graphics.width - 107
      textpos2.push([trainer.name, Graphics.width - 103, 40, :left, base, nil])
    end
    trainer.party.each_with_index do |pkmn, i|
        @sprites["poke_bar_#{side}_#{i}"] = Sprite.new(@viewport)
        @sprites["poke_bar_#{side}_#{i}"].bitmap = Bitmap.new("Graphics/UI/Tournament Selection/poke_bar")
        @sprites["poke_bar_#{side}_#{i}"].src_rect.set(0, 0, 206, 39)
        @sprites["poke_bar_#{side}_#{i}"].x = x_poke_bar
        @sprites["poke_bar_#{side}_#{i}"].y = y_poke_bar
        @sprites["poke_bar_#{side}_#{i}"].z = 1
        @sprites["poke_bar_#{side}_#{i}"].visible = true
        @sprites["poke_bar_#{side}_#{i}"].mirror = true if side == "opponent"
        if side == "player"  #sel bars
          @sprites["poke_sel_bar_#{side}_#{i}"] = Sprite.new(@viewport)
          @sprites["poke_sel_bar_#{side}_#{i}"].bitmap = Bitmap.new("Graphics/UI/Tournament Selection/poke_bar")
          @sprites["poke_sel_bar_#{side}_#{i}"].src_rect.set(206, 0, 206, 39)
          @sprites["poke_sel_bar_#{side}_#{i}"].x = x_poke_bar
          @sprites["poke_sel_bar_#{side}_#{i}"].y = y_poke_bar
          @sprites["poke_sel_bar_#{side}_#{i}"].z = 1
          @sprites["poke_sel_bar_#{side}_#{i}"].opacity = 0
        end
        @sprites["pokeicon_#{side}_#{i}"] = PokemonIconSprite.new(pkmn, @viewport)
        @sprites["pokeicon_#{side}_#{i}"].setOffset(PictureOrigin::CENTER)
        @sprites["pokeicon_#{side}_#{i}"].x       = x_poke_icon
        @sprites["pokeicon_#{side}_#{i}"].y       = y_poke_icon
        @sprites["pokeicon_#{side}_#{i}"].z       = 3
        @sprites["pokeicon_#{side}_#{i}"].visible = true
        @sprites["pokeicon_#{side}_#{i}"].mirror = true if side == "player"
        if side == "player"
          @sprites["nums#{i}"] = Sprite.new(@viewport)
          @sprites["nums#{i}"].bitmap = Bitmap.new("Graphics/UI/Tournament Selection/nums")
          @sprites["nums#{i}"].src_rect.set(0, 0, 24, 26)
          @sprites["nums#{i}"].x = 204
          @sprites["nums#{i}"].y = y_nums
          @sprites["nums#{i}"].z = 4
          @sprites["nums#{i}"].visible = false
        end
        if pkmn.hasItem? && (side == "player" || (@show_items == true && side == "opponent"))
          @sprites["item_#{side}_#{i}"] = ItemIconSprite.new(x_item, y_poke_icon + 6, pkmn.item_id, @viewport)
          @sprites["item_#{side}_#{i}"].blankzero = true
          @sprites["item_#{side}_#{i}"].z       = 2
          @sprites["item_#{side}_#{i}"].zoom_x /= 2
          @sprites["item_#{side}_#{i}"].zoom_y /= 2
        end
        textpos1.push([pkmn.name, x_poke_txt, (y_poke_bar + 7), :left, base, nil])
        textpos2.push([_INTL("Lv.") + pkmn.level.to_s, x_poke_txt, (y_poke_bar + 20), :left, base, nil])
        draw_gender(pkmn,x_gender,y_poke_icon)
        y_nums += 51
        y_poke_bar += 51
        y_poke_icon += 51
    end
    textsprites1 = @sprites["textsprites1"].bitmap
    textsprites2 = @sprites["textsprites2"].bitmap
    pbSetSystemFont(textsprites1)
    pbSetSystemFont(textsprites2)
    MessageConfig.pbSetSmallFont(textsprites1)
    MessageConfig.pbSetVerySmallFont(textsprites2)
    pbDrawTextPositions(textsprites1, textpos1)
    pbDrawTextPositions(textsprites2, textpos2)
    @sprites["trainer_#{side}"] = IconSprite.new(0, 0, @viewport)
    if side == "player"
      @sprites["trainer_#{side}"].setBitmap(GameData::TrainerType.player_front_sprite_filename($player.trainer_type))
      @sprites["trainer_#{side}"].src_rect.set(0,0,@sprites["trainer_#{side}"].bitmap.width,(@sprites["trainer_#{side}"].bitmap.height) / 2)
      @sprites["trainer_#{side}"].mirror = true
      @sprites["trainer_#{side}"].x = -40
      @sprites["trainer_#{side}"].y = -8
      @sprites["trainer_#{side}"].z = 3
    elsif side == "opponent"
      @sprites["trainer_#{side}"].setBitmap(GameData::TrainerType.front_sprite_filename(@trainer_0[0]))
      @sprites["trainer_#{side}"].src_rect.set(0,0,@sprites["trainer_#{side}"].bitmap.width,(@sprites["trainer_#{side}"].bitmap.height) / 2)
      @sprites["trainer_#{side}"].x = Graphics.width - 95
      @sprites["trainer_#{side}"].y = -8
      @sprites["trainer_#{side}"].z = 3
    end
  end

  def draw_gender(pkmn,x,y)
    return if pkmn.egg? || pkmn.genderless?
    gender_text  = (pkmn.male?) ? _INTL("♂") : _INTL("♀")
    base_color   = (pkmn.male?) ? Color.new(0, 112, 248) : Color.new(232, 32, 16)
    textsprites3 = @sprites["textsprites3"].bitmap
    pbSetSystemFont(textsprites3)
    MessageConfig.pbSetVerySmallFont(textsprites3)
    pbDrawTextPositions(textsprites3,
                        [[gender_text, x, y + 5, :left, base_color, nil]])
  end

  def draw_animation(name, path, z = 0)
    Dir.glob(File.join(path, "*.{png,jpg,jpeg,bmp}")).each_with_index do |file, i|
      @sprites["#{name}_#{i}"] = Sprite.new(@viewport)
      @sprites["#{name}_#{i}"].bitmap = Bitmap.new(file)
      @sprites["#{name}_#{i}"].z = z
      @sprites["#{name}_#{i}"].visible = false
    end
  end

  def vfx_animation
    @sprites["bg_#{@loopnum}"].visible = true
    @sprites["particles_#{@loopnum}"].visible = true
     if @loopnum > 0
      @sprites["bg_#{@loopnum-1}"].visible = false
      @sprites["particles_#{@loopnum-1}"].visible = false
     else
      @sprites["bg_238"].visible = false
      @sprites["particles_238"].visible = false
     end
  end

  def sel_anim(sel)
    @sprites["poke_sel_bar_player_#{sel}"].opacity += 8 if @sel_anim_count <= 31
    @sprites["poke_sel_bar_player_#{sel}"].opacity -= 8 if @sel_anim_count >= 41 && @sel_anim_count <= 73
    @sel_anim_count += 1
    @sel_anim_count = 0 if @sel_anim_count > 73
  end

  def anim_oppo_choose #played in the main loop
    return if @num_ball == @poke_max || @white_fade_end == false
    if @loopnum > 32
      create_clone(@sprites["ball_opp0"]) if @num_ball == 0 && @clone == false
      white_fade_anim(@sprites["ball_opp0"]) if @num_ball == 0
      return if @num_ball == @poke_max
      create_clone(@sprites["ball_opp1"]) if @num_ball == 1 && @clone == false
      white_fade_anim(@sprites["ball_opp1"]) if @num_ball == 1
      return if @num_ball == @poke_max
      create_clone(@sprites["ball_opp2"]) if @num_ball == 2 && @clone == false
      white_fade_anim(@sprites["ball_opp2"]) if @num_ball == 2
      return if @num_ball == @poke_max
      create_clone(@sprites["ball_opp3"]) if @num_ball == 3 && @clone == false
      white_fade_anim(@sprites["ball_opp3"]) if @num_ball == 3
      return if @num_ball == @poke_max
      create_clone(@sprites["ball_opp4"]) if @num_ball == 4 && @clone == false
      white_fade_anim(@sprites["ball_opp4"]) if @num_ball == 4
      return if @num_ball == @poke_max
      create_clone(@sprites["ball_opp5"]) if @num_ball == 5 && @clone == false
      white_fade_anim(@sprites["ball_opp5"]) if @num_ball == 5
    end
  end

  def white_fade_anim(sprite,once = false)
    return if once == true && @white_fade_end == true
    @sprites["clone"].opacity += 16 if @loop_white_fade > 50 && @loop_white_fade < 66
    sprite.visible = true if @loop_white_fade == 68
    @sprites["clone"].opacity -= 16 if @loop_white_fade > 70
    @sprites["clone"].zoom_x += 0.1 if @loop_white_fade > 70
    @sprites["clone"].zoom_y += 0.1 if @loop_white_fade > 70
    @loop_white_fade += 1
    if @loop_white_fade >= 86
      @sprites["clone"].dispose 
      @clone = false
      @loop_white_fade = 0
      @num_ball += 1 if once == false
      @white_fade_end = true if once == true
    end
  end

  def create_clone(sprite,once = false, player = nil)
    @sprites["clone#{player}"] = Sprite.new(@viewport)
    @sprites["clone#{player}"].bitmap = sprite.bitmap
    @sprites["clone#{player}"].x = sprite.x
    @sprites["clone#{player}"].y = sprite.y
    @sprites["clone#{player}"].z = sprite.z
    @sprites["clone#{player}"].ox = sprite.ox
    @sprites["clone#{player}"].oy = sprite.oy
    @sprites["clone#{player}"].color = Color.new(252, 252, 252)
    @sprites["clone#{player}"].opacity = 0
    @clone = true if once == false
  end

  def anim_player_choose #played in the main loop
    if @animated_ball[0][:enable] == true
      white_fade_anim_player(0) #making them arguments to be more simple
    elsif @animated_ball[1][:enable] == true
      white_fade_anim_player(1)
    elsif @animated_ball[2][:enable] == true
      white_fade_anim_player(2)
    elsif @animated_ball[3][:enable] == true
      white_fade_anim_player(3)
    elsif @animated_ball[4][:enable] == true
      white_fade_anim_player(4)
    elsif @animated_ball[5][:enable] == true
      white_fade_anim_player(5)
    end
  end

  def white_fade_anim_player(i)
    @sprites["clone#{i}"].opacity += 16 if @animated_ball[i][:time] < 16
    #time = 16, 17, 18, 19, 20 : no animation
    @sprites["ball#{i}"].visible = true if @animated_ball[i][:time] == 18
    @sprites["clone#{i}"].opacity -= 16 if @animated_ball[i][:time] > 20
    @sprites["clone#{i}"].zoom_x += 0.1 if @animated_ball[i][:time] > 20
    @sprites["clone#{i}"].zoom_y += 0.1 if @animated_ball[i][:time] > 20
    @animated_ball[i][:time] += 1
    if @animated_ball[i][:time] >= 36
      @sprites["clone#{i}"].dispose
      @animated_ball[i][:time] = 0
      @animated_ball[i][:enable] = false
    end
  end

  def open_pokemon_summary(pkmn_index)
    return if pkmn_index < 0 || pkmn_index >= $player.party.length
    pbFadeOutIn do
      scene = PokemonSummary_Scene.new
      screen = PokemonSummaryScreen.new(scene)
      screen.pbStartScreen($player.party, pkmn_index)
    end
  end

  def show_commands_menu(sel,commands, fixed = false)
    ret = -1
    y_window = 0
    sel.times do
      y_window += 51
    end
    y_window =  Graphics.height - 194 if fixed == true
    using(cmdwindow = Window_CommandPokemon.new(commands)) do
      cmdwindow.z = 99999
      cmdwindow.index = 0
      cmdwindow.x = 206
      cmdwindow.x = 358 if fixed == true
      cmdwindow.y = y_window
      cmdwindow.visible = true
      cmdwindow.viewport = @viewport
      loop do
        Graphics.update
        Input.update
        white_fade_anim(@sprite_white_anim,true)
        anim_player_choose
        white_fade_anim(@sprites["ball_bar"],true)
        anim_oppo_choose
        vfx_animation
        sel_anim(sel)
        cmdwindow.update
        if Input.trigger?(Input::BACK)
          pbPlayCancelSE
          ret = 2
          break
        elsif Input.trigger?(Input::USE)
          pbPlayCursorSE
          ret = cmdwindow.index
          break
        end
        @loopnum += 1
        @loopnum = 0 if @loopnum > 238
      end
    end
    return ret
  end

  def draw_confirm_message(sel)
    textsprite = @sprites["textsprites5"].bitmap
    textsprite.clear
    width = 400
    height = 72
    x = (Graphics.width - width) / 2
    y = Graphics.height - 100
    shadow = Color.new(176, 176, 176)
    shadow_color = Color.new(0, 0, 0, 140)
    outer_color = Color.new(40, 40, 40, 220)
    inner_color = Color.new(248, 248, 248, 255)
    border_color = Color.new(168, 168, 168, 255)
    textsprite.fill_rect(x + 4, y + 4, width, height, shadow_color)
    textsprite.fill_rect(x, y, width, height, outer_color)
    textsprite.fill_rect(x + 4, y + 4, width - 8, height - 8, inner_color)
    textsprite.fill_rect(x + 2, y + 2, width - 4, height - 4, outer_color)
    textsprite.fill_rect(x + 6, y + 6, width - 12, height - 12, inner_color)
    textsprite.fill_rect(x + 2, y + 2, width - 4, 1, border_color)
    textsprite.fill_rect(x + 2, y + height - 3, width - 4, 1, border_color)
    textsprite.fill_rect(x + 2, y + 2, 1, height - 4, border_color)
    textsprite.fill_rect(x + width - 3, y + 2, 1, height - 4, border_color)
    pbSetSystemFont(textsprite)
    pbDrawTextPositions(textsprite,
                        [[_INTL("Are you happy with these choices?"), Graphics.width / 2, y + 26, :center, Color.new(76, 76, 76), shadow]])
    @sprites["textsprites5"].visible = true
  end

  def hide_confirm_message
    @sprites["textsprites5"].visible = false
  end

  def create_team_data
    team = {}
    $player.party.each_with_index do |pkmn, i|
      team["slot#{i}"] = {
      "pokemon#{i}" => pkmn,
      "choose_num" => nil
      } 
    end
    return team
  end

  def reset_selection_visuals
    @poke_max.times do |i|
      @sprites["ball#{i}"].visible = false if @sprites["ball#{i}"]
    end
    $player.party.each_with_index do |_, i|
      next unless @sprites["nums#{i}"]
      @sprites["nums#{i}"].visible = false
      @sprites["nums#{i}"].src_rect.set(0, 0, 24, 26)
    end
  end

  def main_loop
    new_team = []
    team_data = create_team_data
    @animated_ball = [{enable: false, time: 0},{enable: false, time: 0},{enable: false, time: 0},{enable: false, time: 0},{enable: false, time: 0},{enable: false, time: 0}]
    @loopnum = 0
    @sel_anim_count = 0
    @clone = false
    @loop_white_fade = 51                                                             #starts at 51 for the bar
    @num_ball = 0
    @white_fade_end = false
    @sprite_white_anim = @sprites["ball_bar"]                                         #prevents ball white fade to animate and tells when bars animate
    sel = 0
    create_clone(@sprites["ball_bar"], true)
    fade_out(true)
    loop do
      Graphics.update
      Input.update
      white_fade_anim(@sprite_white_anim,true)
      anim_player_choose
      anim_oppo_choose
      vfx_animation
      sel_anim(sel)
      x_src_rect = 0
      if Input.trigger?(Input::USE)
        pbPlayDecisionSE
        if team_data["slot#{sel}"]["choose_num"] != nil
          commands = [_INTL("Retire"), _INTL("Summary"), _INTL("Cancel")]
        else
          commands = [_INTL("Enter"), _INTL("Summary"), _INTL("Cancel")]
        end
        choice = show_commands_menu(sel,commands)
        case choice
        when 0
          if team_data["slot#{sel}"]["choose_num"] != nil
            @sprites["nums#{sel}"].visible = false
            new_team.delete_at(team_data["slot#{sel}"]["choose_num"] - 1)
            team_data.length.times do |i|
              next if !team_data["slot#{i}"]["choose_num"]
              if team_data["slot#{sel}"]["choose_num"] < team_data["slot#{i}"]["choose_num"] #checks higher other choices and reduce them by one stage
                team_data["slot#{i}"]["choose_num"] -= 1
                x_src_rect = team_data["slot#{i}"]["choose_num"] * 24 - 24
                @sprites["nums#{i}"].src_rect.set(x_src_rect, 0, 24, 26)
              end
            end
            team_data["slot#{sel}"]["choose_num"] = nil
            @poke_max.times do |i|
              @sprites["ball#{i}"].visible = false
            end
            team_data.each_value do |slot|
              next unless slot["choose_num"].to_i > 0
              @sprites["ball#{slot["choose_num"].to_i - 1}"].visible = true
            end
          else
            x_src_rect = new_team.length * 24
            @sprites["nums#{sel}"].src_rect.set(x_src_rect, 0, 24, 26)
            @sprites["nums#{sel}"].visible = true
            new_team.push(team_data["slot#{sel}"]["pokemon#{sel}"])
            team_data["slot#{sel}"]["choose_num"] = new_team.length
            create_clone(@sprites["ball#{new_team.length - 1}"], true, new_team.length - 1)
            @animated_ball[new_team.length - 1][:enable] = true
            #pbMessage(_INTL("{1} has been entered.", $player.party[sel].name))
            if team_data["slot#{sel}"]["choose_num"] == @poke_max
              pbPlayDecisionSE
              draw_confirm_message(sel)
              commands = [_INTL("Yes"), _INTL("No")]
              choice = show_commands_menu(sel,commands,true)
              hide_confirm_message
              case choice
              when 0
                $PokemonGlobal.tournamentSelection = true
                $PokemonGlobal.notSelectedParty = $player.party - new_team
                $player.party = new_team
                break
              when 1
                pbPlayCloseMenuSE
                reset_selection_visuals
                new_team = []
                team_data = create_team_data
                @animated_ball.each do |ball|
                  ball[:enable] = false
                  ball[:time] = 0
                end
              end
            end
          end
        when 1
          open_pokemon_summary(sel)
        when 2
          # Cancelled
        end
      elsif Input.trigger?(Input::UP)
        pbPlayCursorSE
        @sprites["poke_sel_bar_player_#{sel}"].opacity = 0
        sel -= 1
        sel = $player.party.length - 1 if sel == -1
        @sprites["poke_sel_bar_player_#{sel}"].opacity = 255
        @sel_anim_count = 32
      elsif Input.trigger?(Input::DOWN)
        pbPlayCursorSE
        @sprites["poke_sel_bar_player_#{sel}"].opacity = 0
        sel += 1
        sel = 0 if sel == $player.party.length
        @sprites["poke_sel_bar_player_#{sel}"].opacity = 255
        @sel_anim_count = 32
      end
      @loopnum += 1
      @loopnum = 0 if @loopnum > 238
    end
  end

  def fade_in
    16.times do
      @viewport_foreground.tone.red -= 16
      @viewport_foreground.tone.green -= 16
      @viewport_foreground.tone.blue -= 16
      Graphics.update
    end
  end

  def fade_out(start = false)
    16.times do
      @viewport_foreground.tone.red += 16
      @viewport_foreground.tone.green += 16
      @viewport_foreground.tone.blue += 16
      vfx_animation if start == true
      Graphics.update
    end
  end

  def end_fade
    fade_in
    pbDisposeSpriteHash(@sprites)
    fade_out
    @viewport_foreground.dispose
  end

end
