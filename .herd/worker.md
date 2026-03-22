# Worker Instructions

## Testing Requirements

When implementing any feature or bugfix, always write tests at every applicable level:

- **Unit tests** (`test/models/`, `test/helpers/`, `test/mailers/`, `test/jobs/`) — test individual models, helpers, mailers, and jobs in isolation.
- **Integration tests** (`test/integration/`, `test/controllers/`) — test controller actions, request/response cycles, and multi-component interactions.
- **System tests** (`test/system/`) — test full user-facing flows in a browser using Capybara and Selenium.

Write tests at all three levels when the change touches user-facing behavior. If a level does not apply (e.g., a pure model change has no system test), skip it, but default to writing more tests rather than fewer.

Follow the existing test conventions:
- Use `ActiveSupport::TestCase` as the base class.
- Use fixtures from `test/fixtures/*.yml`.
- Use Minitest assertions (`assert`, `assert_equal`, `assert_difference`, etc.).

## Pre-Completion Checklist

Before calling the task done, you **must** run the following commands and ensure they all pass:

1. **Tests:** `bin/rails test` (unit and integration tests)
2. **System tests:** `bin/rails test:system` (system tests, if any were written)
3. **Linter:** `bin/rubocop` (Ruby style checks using rubocop-rails-omakase)

If any command fails, fix the issues and re-run until all three pass. Do not mark the task as complete with failing tests or linter violations.
