class Monpoke
    attr_reader :monpoke_id, :ap, :hp  

    def initialize(monpoke_id, hp, ap)
        if hp.to_i <= 0 || ap.to_i <= 0
            raise "A Monpoke's HP and AP must be greater than 0"
        end
        @monpoke_id = monpoke_id
        @hp = hp.to_i
        @ap = ap.to_i
    end

    def get_hit(enemy_attack)
        @hp -= enemy_attack
        # return "#{@enemy.monpoke_id} attacked #{@monpoke_id} for #{enemy.ap} damage!"
    end

    def defeated?
        return @hp <= 0
    end
end

class Team
    attr_reader :team_id, :monpokes, :chosen

    def initialize(team_id)
        @team_id = team_id
        @monpokes = []
        @chosen = nil
    end

    def add_monpoke(monpoke)
        @monpokes << monpoke
    end

    def choose_you(monpoke_id)
        monpoke_index = @monpokes.index { |m| m.monpoke_id == monpoke_id }
        if monpoke_index && !@monpokes[monpoke_index].defeated?
            @chosen = @monpokes[monpoke_index]
            return @chosen
        else
            @chosen = nil
        end
    end

    def team_valid?
        return @monpokes.any? { |m| !m.defeated? }
    end
end

class Game
    attr_reader :team_1, :team_2, :current_team
    def initialize
        @team_1 = nil
        @team_2 = nil
        @current_team = nil
    end
    
    def create(team_id, monpoke_id, hp, ap)
        monpoke = Monpoke.new(monpoke_id, hp, ap)
        if !@team_1
            @team_1 = Team.new(team_id)
            @team_1.add_monpoke(monpoke)
            @current_team = @team_1
        elsif @team_1.team_id == team_id
            @team_1.add_monpoke(monpoke)
        elsif !@team_2
            @team_2 = Team.new(team_id)
            @team_2.add_monpoke(monpoke)
            @current_team = @team_2
        elsif @team_2.team_id == team_id
            @team_2.add_monpoke(monpoke)
        else
            exit(1)
        end
        return "#{monpoke_id} has been assigned to #{team_id}!"
    end

    def attack
        if !@team_1 || !@team_2
            exit(1)
        end
        if @current_team == @team_1
            @team_2.chosen.get_hit(@team_1.chosen.ap)
            return "#{@team_1.chosen.monpoke_id} attacked #{@team_2.chosen.monpoke_id} for #{@team_1.chosen.ap} damage!"
        else
            @team_1.chosen.get_hit(@team_2.chosen.ap)
            return "#{@team_2.chosen.monpoke_id} attacked #{@team_1.chosen.monpoke_id} for #{@team_2.chosen.ap} damage!"
        end   
    end

    def ichooseyou(monpoke_id)
        @current_team.choose_you(monpoke_id)
        if @current_team.chosen
            return "#{monpoke_id} has entered the battle!"
        else
            exit(1)
        end
    end

    def defeated_announcement
        if @team_1.chosen.defeated?
            puts "#{@team_1.chosen.monpoke_id} has been defeated!"
        elsif @team_2.chosen.defeated?
            puts "#{@team_2.chosen.monpoke_id} has been defeated!"
        end
    end

    def game_over?
        if @team_1 && @team_2
            if !@team_1.team_valid?
                return "#{@team_2.team_id} is the winner!"
            elsif !@team_2.team_valid?
                return "#{@team_1.team_id} is the winner!"
            end
        end
    end

    def switch
        if @team_1 && @team_2
            if @current_team == @team_1
                @current_team = @team_2
            else
                @current_team = @team_1
            end
        end
    end

end