APP_NAME=tvdb_api
GREEN := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
RESET := $(shell tput -Txterm sgr0)

.DEFAULT_GOAL := help

# 🧩 Local Development
install: ## Install dependencies
	bundle install

console: ## Start interactive Ruby console with gem loaded
	bundle exec irb -r ./lib/tvdb_api

# 🧪 Testing
test: ## Run all tests
	bundle exec rspec

test.focus: ## Run tests with focus tag
	bundle exec rspec --tag focus

# 🔍 Linting & Security
lint: ## Run RuboCop linter
	bundle exec rubocop

lint.fix: ## Auto-fix RuboCop offenses
	bundle exec rubocop -A

# ✅ CI
check: lint test ## Run all checks (lint + test)

# 📦 Build & Release
build: ## Build the gem
	gem build tvdb_api.gemspec

clean: ## Remove built gems
	rm -f *.gem

# 📖 Help
help: ## Show all available make targets
	@echo "$(GREEN)$(APP_NAME) - Available targets:$(RESET)"
	@grep -E '^[a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(RESET) %s\n", $$1, $$2}'

.PHONY: install console test test.focus lint lint.fix check build clean help
