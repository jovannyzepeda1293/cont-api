# README

## Rails Project with Redis and Sidekiq

This project uses Ruby on Rails, PostgreSQL, Redis, and Sidekiq for background job processing.

### Requirements
- Ruby 3.3.5
- Rails ~> 7.1.4
- PostgreSQL
- Redis
- Bundler

## Environment Variables

### Copy the example file:
`cp .env.example .env`

### Update the .env file with your local values.
- Do not commit .env with real secrets.

### Local Database Setup

**Connect to PostgreSQL as the postgres user:** `sudo -u postgres psql`

**Create a user and grant permissions:**

`CREATE USER your_database_user WITH PASSWORD 'your_database_password';`

`ALTER USER your_database_user CREATEDB CREATEROLE;`


**Create the test database and load schema:**

`rake db:create RAILS_ENV=test`

`rails db:schema:load RAILS_ENV=test`

### Install Dependencies
`bundle install`

### Install and Start Redis
**Linux**
`redis-server`

**macOS with Homebrew**
`brew install redis`

`brew services start redis`

*Make sure Redis is running before starting Sidekiq.*

### Running the Project

*Start the Rails server:*

`rails s`


*Start Sidekiq:*

`bundle exec sidekiq`

### Notes

Redis must be running before executing Sidekiq.

Use .env for environment variables.

How to run tests: `rspec ./spec`
