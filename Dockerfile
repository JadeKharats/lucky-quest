# --- Shards: production dependencies only ----------------------------------
# Installed first because the Bun stage needs Lucky's bundled build script
# (lib/lucky/src/bun).
FROM crystallang/crystal:1.21.0-alpine AS shards

RUN apk add --no-cache git

WORKDIR /app
COPY shard.yml shard.lock ./
RUN shards install --production --skip-postinstall --skip-executables

# --- Assets: fingerprinted, minified JS/CSS + bun-manifest.json -------------
FROM oven/bun:1.4.3-alpine AS assets

WORKDIR /app
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile --production

COPY --from=shards /app/lib/lucky/src/bun ./lib/lucky/src/bun
COPY src/js ./src/js
COPY src/css ./src/css
COPY public ./public
RUN bun run prod

# --- Build: dynamic binaries + their shared libraries ----------------------
# Same approach as the other Happy apps (spider-gazelle style): link
# dynamically and ship the exact libraries `ldd` reports, so each library can
# be patched independently. The PostgreSQL driver is pure Crystal: no libpq.
FROM crystallang/crystal:1.21.0-alpine AS build

ARG IMAGE_UID=10001
ENV UID=$IMAGE_UID
ENV APP_USER=appuser
ENV LUCKY_ENV=production

RUN apk add --no-cache ca-certificates
RUN adduser -D -g "" -H -s /sbin/nologin -u "${UID}" "${APP_USER}"

WORKDIR /app
COPY --from=shards /app/lib ./lib
COPY shard.yml shard.lock tasks.cr ./
COPY config ./config
COPY db ./db
COPY tasks ./tasks
COPY src ./src
# The asset manifest is read at compile time, so it must exist before building.
COPY --from=assets /app/public ./public

# Two binaries: the web server, and the tasks (`db.migrate`, `users.create`).
RUN mkdir -p bin && \
    crystal build src/start_server.cr -o bin/quest --release --no-debug && \
    crystal build tasks.cr -o bin/quest-tasks --release --no-debug && \
    strip bin/quest bin/quest-tasks

RUN for binary in /app/bin/*; do \
      ldd "$binary" | tr -s '[:blank:]' '\n' | grep '^/' | \
      xargs -I % sh -c 'mkdir -p $(dirname "deps%"); cp "%" "deps%";'; \
    done

# --- Final stage: scratch, unprivileged, only what runs --------------------
FROM scratch

ENV LUCKY_ENV=production
ENV PORT=3000
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group
COPY --from=build /etc/hosts /etc/hosts
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=build /app/deps /
COPY --from=build /app/bin/quest /app/bin/quest-tasks /app/
# Lucky serves ./public relative to the working directory.
COPY --from=build /app/public /app/public
WORKDIR /app

USER appuser:appuser
EXPOSE 3000
ENTRYPOINT ["/app/quest"]
