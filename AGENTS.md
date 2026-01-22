# Repository Guidelines

## Project Structure & Module Organization
- `bot.py` is the main entry point and contains the bot runtime logic.
- `settings.py` holds local configuration; use `settings.py.sample` as the template.
- `screenshot/` contains documentation assets used by `README.md`.
- `telegram-shell-bot.yml` (pm2) and `Procfile` define process manager configs.
- `upload/` is created at runtime when users send files to the bot.

## Build, Test, and Development Commands
- `poetry install --only main`: install runtime dependencies.
- `poetry shell`: activate the virtual environment.
- `python bot.py` or `make run`: start the bot locally.
- `make pyenv`: convenience target to install deps and enter the venv.
- `pm2 start telegram-shell-bot.yml`: production-style run with pm2.
- `make init-pre-commit`: install and run repo linters via pre-commit.

## Coding Style & Naming Conventions
- Python 3.8+ with 4-space indentation and snake_case names.
- Formatting: Black with 88-char lines (`pyproject.toml`).
- Imports: isort with the Black profile.
- Linting: flake8 with 88-char lines (`setup.cfg`).
- Keep new files consistent with `.editorconfig` where applicable.

## Testing Guidelines
- No automated test suite is currently included.
- Manually verify changes by running the bot and exercising key commands
  (e.g., `/tasks`, `/download`, `/script`) against a test bot.
- If you add tests, document the runner and naming scheme in this file.

## Commit & Pull Request Guidelines
- Recent commit messages are short, imperative sentences (e.g., “add support
  for upload to server”). Keep them concise and action-focused.
- PRs should describe behavior changes, include manual test notes, and call
  out any config or security-impacting updates.

## Security & Configuration Tips
- Never commit real tokens; keep `settings.py` local and start from
  `settings.py.sample`.
- Restrict access with `ENABLED_USERS` and prefer `CMD_WHITE_LIST` or
  `ONLY_SHORTCUT_CMD` when running on shared hosts.
- Avoid running the bot as root; treat shell access as sensitive.
