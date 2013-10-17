require 'spec_helper'
describe "Episodes API" do
  describe 'GET /episodes.json' do
    let(:valid_attributes){["id", "name", "description", "published_at", "seconds"]}

    it "send a list of episodes" do
      create_list(:episode, 10)

      get '/episodes'

      expect(response).to be_success
      expect(json['episodes'].length).to eq(10)
      expect(json['episodes'].first).to only_contain(valid_attributes)
    end
    

    describe "?tag_id=" do
      it 'send a list of episodes associated to tag_id' do
        tag = create(:tag, :name => "Oldtimes")
        ep1 = create(:episode, :name => "Blast from the Past", :tags => [tag])
        ep2 = create(:episode, :name => "Back to the Future")
        
        get '/episodes', {tag_id: tag.id}
        
        expect(response).to be_success
        expect(json['episodes'].length).to eq(1)
        expect(json['episodes'].first['id']).to eq(ep1.id)
        expect(json['episodes'].first).to only_contain(valid_attributes)
      end
    end
    describe "?search=" do
      it 'send a list of episodes containing search key' do
        ep1 = create(:episode, :name => "Blast from the Past")
        ep2 = create(:episode, :name => "Back to the Future")
        
        get '/episodes', {search: "Future"}
        
        expect(response).to be_success
        expect(json['episodes'].length).to eq(1)
        expect(json['episodes'].first['id']).to eq(ep2.id)
        expect(json['episodes'].first).to only_contain(valid_attributes)
      end
    end
  end
  describe 'GET /episodes/:id.json' do
    let(:valid_attributes){["id", "name", "description", "published_at", "seconds", 
    "comments", "notes"]}
    let(:episode) {create(:episode, :name => "Back to the Future")}

    it "sends the episode details" do
      get "episodes/#{episode.position}-anything"

      expect(response).to be_success
      expect(json['episode_detailed']).to only_contain(valid_attributes)
    end
  end
  describe 'POST /episodes.json' do
    it "reports unauthorized access when attempting to create an episode as a normal user" do
    end

    it "creates a new episode with default position" do
    end
  end
  describe 'PATCH /episodes.json' do
    it "edits an episode as admin" do
    end

    it "edits an episode show notes as moderator" do
    end
  end
end
