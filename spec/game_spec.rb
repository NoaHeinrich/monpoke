require_relative '../classes.rb'
RSpec.describe Monpoke do 
    before(:each) do 
        @monpoke = Monpoke.new("Chikapu", 10, 10)
    end

    describe "#initialize" do 
        it "raises an exception if given HP less than or equal to 0" do 
            expect {
                Monpoke.new("Zardichar", 0, 10).to raise_error
            }
        end

        it "raises an exception if given AP less than or requal to 0" do 
            expect {
                Monpoke.new("Zardichar", 10, 0).to raise_error
            }
        end
    end
    
    describe "#get_hit" do 
        it "lowers the Monpoke's HP by the damage given" do 
            @monpoke.get_hit(5)
            expect(@monpoke.hp).to eq(5)
        end
    end

    describe "#defeated?" do 
        it "returns true if the Monpoke's HP is 0" do 
            @monpoke.get_hit(10)
            expect(@monpoke.defeated?).to be_truthy          
        end

        it "returns true if the Monpoke's HP is less than 0" do 
            @monpoke.get_hit(15)
            expect(@monpoke.defeated?).to be_truthy
        end

        it "returns false if the Monpoke has positive HP" do 
            expect(@monpoke.defeated?).to be_falsey
        end
    end
end

RSpec.describe Team do 
    before(:each) do
        @team = Team.new("Firecracker")
        @chikapu = Monpoke.new("Chikapu", 10, 10)
    end

    describe "#add_monpoke" do 
        it "adds a given monpoke to the roster" do 
            @team.add_monpoke(@chikapu)
            expect(@team.monpokes).to include(@chikapu)
        end
    end

    describe "#choose_you" do 
        it "sets the monpoke as the chosen" do 
            @team.add_monpoke(@chikapu)
            @team.choose_you('Chikapu')
            expect(@team.chosen).to be(@chikapu)
        end

        it "says if the monpoke selected is not added" do 
            @team.choose_you('Chikapu')
            expect(@team.chosen).to be_nil
        end

        it 'does not select a monpoke who has been defeated' do 
            @team.add_monpoke(@chikapu)
            @chikapu.get_hit(10)
            @team.choose_you('Chikapu')
            expect(@team.chosen).to be_nil
        end
    end

    describe '#team_valid?' do 
        it 'returns true if a team member is not defeated' do 
            @team.add_monpoke(@chikapu)
            expect(@team.team_valid?).to be_truthy
        end

        it "returns false if all team members are defeated" do 
            @team.add_monpoke(@chikapu)
            @chikapu.get_hit(10)
            expect(@team.team_valid?).to be_falsey
        end

        it "returns false if a larger team is all defeated" do
            @team.add_monpoke(@chikapu)
            zarichard = Monpoke.new('Zarichard', 10, 10)
            twomew = Monpoke.new('Twomew', 10, 10)
            @team.add_monpoke(zarichard)
            @team.add_monpoke(twomew)
            @chikapu.get_hit(10)
            zarichard.get_hit(10)
            twomew.get_hit(10)
            expect(@team.team_valid?).to be_falsey
        end
    end
end

RSpec.describe Game do 
    before(:each) do
        @game = Game.new 
    end

    describe "#create" do 
        it "creates team 1 if team 1 has not yet been created" do 
            @game.create('Firecracker', 'Twomew', 10, 10)
            expect(@game.team_1).to be_a(Team)
        end

        it "creates team 2 if team 1 has been created but team 2 has not" do
            @game.create('Firecracker', 'Twomew', 10, 10)
            @game.create('Lava', 'Marmag', 10, 10)
            expect(@game.team_2).to be_a(Team)
        end

        it "adds a new Monpoke to an existing team" do 
            @game.create('Firecracker', 'Twomew', 10, 10)
            @game.create('Firecracker', 'Zarichard', 10, 10)
            expect(@game.team_1.monpokes.length).to eq(2)
        end
    end

    describe "#ichooseyou" do 
        it "returns a string if the chosen monpoke exists in the current team" do 
            @game.create('Firecracker', 'Twomew', 10, 10)
            @game.create('Lava', 'Marmag', 10, 10)
            expect(@game.ichooseyou('Marmag')).to eq('Marmag has entered the battle!')
        end
    end

    describe "#attack" do 
        it "announces a successful attack" do 
            @game.create('Firecracker', 'Twomew', 10, 10)
            @game.create('Lava', 'Marmag', 10, 10)
            @game.ichooseyou("Marmag")
            @game.switch
            @game.ichooseyou("Twomew")
            expect(@game.attack).to eq('Twomew attacked Marmag for 10 damage!')
        end
    end

    describe "#switch" do 
        it "switches from player 2 to player 1" do
            @game.create('Firecracker', 'Twomew', 10, 10) 
            @game.create('Lava', 'Marmag', 10, 10)
            @game.switch
            expect(@game.current_team).to eq(@game.team_1)
        end
    end

    describe "#game_over?" do 
        it "reports if a team has no monpokes with hp left" do 
            @game.create('Firecracker', 'Twomew', 10, 10)
            @game.create('Lava', 'Marmag', 10, 10)
            @game.ichooseyou("Marmag")
            @game.switch
            @game.ichooseyou("Twomew")
            @game.attack
            expect(@game.game_over?).to eq('Firecracker is the winner!')
        end
    end
    
end