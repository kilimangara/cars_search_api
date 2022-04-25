# Start Up Application Steps
1. ```cp .env.sample .env```
2. ```docker compose up```

# Swagger documentation

You can get OpenAPI JSON file by accessing ```http://localhost:3001/api/search/v1/swagger_doc```, then you should copy it to swagger online tool e.g [online.swagger](https://editor.swagger.io/).

Unfortunately there is no way to execute requests from UI because of https schema, but you can copy generated CURL command :)

# Solution description

External scoring results caches in DB on table user_cars_scorings. Also Redis cache stores information about each user about information relevance, "user_cars_scoring:#{user.id}:actual" key with expiration option.

There are few flows to fill cache:
1. Runtime Cache. Application tries to fetch recommendations for certain user right in API request. If scoring API doesn't work, application won't fail with 500, just empty rank_scores in results. After successfull caching Redis stores information about this.
2. Sidekiq Job which fetches scorings for batch of users. Job has 5 retries with exponential delay. Jobs start each N hours by cron for example.

# Tests
Tests on:
- [x] API
- [x] - UserCarsQuery
- [x] - ScoringAPI::Client
- [x] - CacheUserRecommendationsService
