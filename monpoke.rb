require './classes.rb'

game = Game.new
commands = STDIN.readlines

commands.each do |command|
    command_array = command.split
    
    case command_array[0].downcase
    when 'create'
        puts game.create(command_array[1], command_array[2], command_array[3], command_array[4])
    when 'attack'
        puts game.attack
        game.defeated_announcement
    when 'ichooseyou'
        puts game.ichooseyou(command_array[1])
    else
        exit(1)
    end
    
    game.switch 

    if game.game_over?
        puts game.game_over?
        break
    end
end