require 'rails_helper'

RSpec.describe "Api::V1::Goals", type: :request do
  let(:headers) { {"ACCEPT" => "application/json"} }
  let(:body)    { JSON.parse(response.body, symbolize_names: true) }
  let(:params)  { {data: { type: "goals", attributes: attributes }} }

  describe "GET /index" do
    let!(:completed_goal) do 
      Timecop.freeze(Date.today - 3.months) do
        create :goal, 
          description: 'Submit essays', 
          target_date: Date.today + 2.months,
          unit_of_measure: 'essays',
          starting_value: 0,
          target_value: 4,
          interval: 'weekly'
      end
    end

    let!(:started_goal) do
      Timecop.freeze(Date.today - 3.months) do
        create :goal, 
          description: 'Grow my thesis', 
          target_date: Date.today + 1.year,
          unit_of_measure: 'pages',
          starting_value: 1,
          target_value: 100,
          interval: 'monthly'
      end
    end

    let!(:new_goal) { create :goal, :valid, interval: 'monthly' }

    before(:each) do
      Goal.find_each do |g|
        tracker = GoalTracker.new(g)
        tracker.create_tracking_schedule
      end
      
      next_val = completed_goal.starting_value 
      completed_goal.stats.each do |s|
        s.update(value: next_val)
        next_val += 0.5
      end

      next_val = 10
      started_goal.stats.due.each do |s|
        s.update(value: next_val)
        next_val += 10
      end
    end

    it 'returns goals with stats' do
      get '/api/v1/goals', headers: headers
      
      expect(body)
    end
  end

  describe "POST /create" do
    let(:goal) { Goal.find(body[:data][:id]) }
    
    context 'with interval set to daily' do
      let(:attributes) do
        {  
          description:     'Work more',
          target_date:     Date.today + 1.year,
          unit_of_measure: 'hours a day',
          starting_value:  2.5,
          target_value:    8,
          interval:        'daily'
        }
      end

      let(:expected_stat_dates) do 
        ((Date.today + 1.day)..(Date.today + 1.year)).to_a 
      end

      it 'creates goal with a daily tracking schedule' do
        post '/api/v1/goals', params: params, headers: headers

        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:created)

        expect(goal.stats.pluck(:date)).to match_array(expected_stat_dates)
      end
    end

    context 'with interval set to weekly' do
      let(:attributes) do
        { 
          description:     'Workout more',
          target_date:     Date.today + 1.year,
          unit_of_measure: 'hours a week',
          starting_value:  1.5,
          target_value:    7,
          interval:        'weekly'
        }
      end

      let(:expected_stat_dates) do 
        ((Date.today + 1.week)..(Date.today + 1.year)).step(7).to_a.push((Date.today + 1.year)) 
      end

      it 'creates goal with a weekly tracking schedule' do
        post '/api/v1/goals', params: params, headers: headers

        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:created)

        expect(goal.stats.pluck(:date)).to match_array(expected_stat_dates)
      end
    end

    context 'with interval set to monthly' do
      let(:attributes) do
        {
          description:     'Create more content',
          target_date:     Date.today + 1.year - 1.week,
          unit_of_measure: 'Medium posts a month',
          starting_value:  0.5,
          target_value:    8,
          interval:        'monthly'
        }
      end

      let(:expected_stat_dates) do 
        [
          Date.today + 1.month,
          Date.today + 2.months,
          Date.today + 3.months,
          Date.today + 4.months,
          Date.today + 5.months,
          Date.today + 6.months,
          Date.today + 7.months,
          Date.today + 8.months,
          Date.today + 9.months,
          Date.today + 10.months,
          Date.today + 11.months,
          Date.today + 1.year - 1.week,
        ]
      end

      it 'creates goal with a monthly tracking schedule' do
        post '/api/v1/goals', params: params, headers: headers

        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:created)

        expect(goal.stats.pluck(:date)).to match_array(expected_stat_dates)
      end
    end

    context 'with interval set to yearly' do
      let(:attributes) do
        {
          description:     'Save enough for a house in Portugal',
          target_date:     Date.today + 10.years,
          unit_of_measure: 'USD',
          starting_value:  10000,
          target_value:    430000,
          interval:        'yearly'
        }
      end

      let(:expected_stat_dates) do 
        [
          Date.today + 1.year,
          Date.today + 2.years,
          Date.today + 3.years,
          Date.today + 4.years,
          Date.today + 5.years,
          Date.today + 6.years,
          Date.today + 7.years,
          Date.today + 8.years,
          Date.today + 9.years,
          Date.today + 10.years,
        ]
      end

      it 'creates goal with a yearly tracking schedule' do
        post '/api/v1/goals', params: params, headers: headers

        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:created)

        expect(goal.stats.pluck(:date)).to match_array(expected_stat_dates)
      end
    end

    context 'with invalid params' do
      let(:attributes) do
        {
          description:     '',
          target_date:     Date.today - 10.days,
          unit_of_measure: '',
          starting_value:  '',
          target_value:    '',
          interval:        'hourly'
        }
      end

      it 'returns 422 with error messages' do
        post '/api/v1/goals', params: params, headers: headers

        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:unprocessable_entity)

        expect(body[:description]).to contain_exactly("can't be blank")
        expect(body[:target_date]).to contain_exactly("should be in the future")
        expect(body[:starting_value]).to contain_exactly("is not a number")
        expect(body[:target_value]).to contain_exactly("is not a number")
        expect(body[:interval]).to contain_exactly("is not included in the list")     
      end
    end
  end

  describe "DELETE /destroy" do
    let(:goal) { create :goal, :valid }

    before(:each) do
      tracker = GoalTracker.new(goal)
      tracker.create_tracking_schedule
    end

    it 'destroy the goal record and associated stats' do
      expect(Goal.count).to eq(1)
      expect(goal.stats.count).to be > 0

      delete "/api/v1/goals/#{goal.id}", headers: headers
      
      expect(Goal.count).to eq(0)
      expect { Goal.find(goal.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(Stat.count).to eq(0)
    end

    context 'with invalid id' do
      it 'returns a 404' do
        expect(Goal.count).to eq(1)
        expect(goal.stats.count).to be > 0

        delete "/api/v1/goals/011111111", headers: headers

        expect(response.status).to eq(404)

        expect(Goal.count).to eq(1)
        expect(goal.stats.count).to be > 0
      end
    end
  end
end
