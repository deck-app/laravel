# Change Log

All notable changes of this project will be documented in this file.

[v2.1.6] - 2022-09-05
-----------------------------------------------------------------------------------
Issue
* Failed to download laravel/laravel from dist curl error.

Added
* **Internet** - Check internet working or not in container.
* **Changelog** - Add to changelog.md file.

Fix
* Added super-user to all the commands  ([f696df1](https://github.com/deck-app/laravel/commit/f696df114835387ad4ea596a5c9170799f5c9e35)).
* Execute for loop in docker-entrypoint.

[v2.1.4] - 2022-08-01
-----------------------------------------------------------------------------------
Here we would have the update steps for v2.1.4 for people to follow.

Added
Changed
Container auto login as a User.

| Stack | Nginx  | Apache |
|-------|--------|--------|
| User  | nobody | apache |

Fixed
* Separate nginx and apache file. ([7ebf757](https://github.com/deck-app/laravel/commit/7ebf757dee0467691fc7037370989d63e93bdb0d))
* Changed permission of all the necessary files and folders and also container login changed ([7ebf757](https://github.com/deck-app/laravel/commit/7ebf757dee0467691fc7037370989d63e93bdb0d))
