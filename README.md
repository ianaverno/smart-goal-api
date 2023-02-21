# Smart goals API

## To play the demo

Clone repo and run the basic dev setup: `bundle` -> `rails db:setup` -> `rails s`.

Then go to [front-end repo](https://github.com/ianaverno/smart-goals-app),
clone `npm install` and `npm run dev`. The front will be at [localhost:3001](localhost:3001)
and trying to reach the API at [localhost:3000](localhost:3000)


## Assumptions

* Stats show progress towards goal, i.e. they are a snapshot and are not cumulative

## Dev notes / Known issues
* Users aren't implemented for this demo, so it's is juse 'god mode' where all
goals are available
* For MVP goal editing API (and tracking recalculation) is not provided
instead members can update goals by deleting and creating new ones with 
new relevant values 
* It's a good idea to use DatabaseCleaner with RSpec, skipped to save time
* Goal request specs could use some improvement in terms of time freezing:
5 of those may fail depending on the time of day they are run