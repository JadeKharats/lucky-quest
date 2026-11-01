# Quest

[![Live](https://img.shields.io/badge/live-quest.yoteau.fr-6b4fbb)](https://quest.yoteau.fr)
[![CI](https://github.com/JadeKharats/lucky-quest/actions/workflows/ci.yml/badge.svg)](https://github.com/JadeKharats/lucky-quest/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-3b7a57)](LICENSE)
[![Container image](https://img.shields.io/badge/ghcr.io-lucky--quest-2496ed?logo=docker&logoColor=white)](https://github.com/JadeKharats/lucky-quest/pkgs/container/lucky-quest)

A small, private, gamified home app for one family — built with Crystal,
[Lucky](https://luckyframework.org) and PostgreSQL. It ships as a **~21 MB**
container built `FROM scratch` and running as an unprivileged user.

There is no public sign-up: accounts are created from the command line.

## Run it

```sh
cat > .env <<ENV
SECRET_KEY_BASE=$(openssl rand -base64 32)
POSTGRES_PASSWORD=$(openssl rand -hex 24)
APP_DOMAIN=http://localhost:3000
ENV

docker compose up -d
docker compose run --rm -it --entrypoint /app/quest-tasks migrate users.create you@example.com
```

Then open http://localhost:3000 and sign in.

## Develop

Requirements: Crystal 1.21 and Bun (see `.tool-versions`), PostgreSQL, and a
Chromium-based browser for the LuckyFlow specs.

```sh
shards install
bun install && bun run build   # the asset manifest is read at compile time
lucky db.setup
crystal spec
lucky dev                      # http://127.0.0.1:3000
```

Database settings come from `DB_HOST`, `DB_PORT`, `DB_USERNAME` and
`DB_PASSWORD` (or `DATABASE_URL`), read from the environment or a `.env` file.

LuckyFlow downloads a chromedriver by default. To use your own (for instance
behind a proxy, or with Brave instead of Chrome), set `CHROMEDRIVER_PATH` to a
driver matching your browser's major version and `CHROME_BIN` to the browser
executable.

## Architecture

The domain lives in `src/domain/` as plain Crystal with no Lucky or Avram
dependency, and is mutation-tested with [crytic](https://github.com/hanneskaeufler/crytic).
Lucky actions and pages, and Avram models and operations, are adapters around it.

## License

[MIT](LICENSE)
