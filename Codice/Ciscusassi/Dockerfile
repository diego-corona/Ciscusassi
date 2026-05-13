# ---- Stage 1: build Angular ----
FROM node:22-bookworm-slim AS builder

WORKDIR /app

# API_URL deve puntare all'indirizzo del backend raggiungibile dal browser
ARG API_URL=http://localhost:3000
ARG TOMTOM_API_KEY=YOUR_TOMTOM_API_KEY
ARG JWT_SECRET_KEY=change_me_in_production

COPY package*.json ./
RUN npm ci

COPY . .

# Genera i file environment a partire dagli ARG
RUN printf 'export const environment = {\n  production: true,\n  tomtomApiKey: "%s",\n  apiURL: "%s",\n  JWT_SECRET_KEY: "%s"\n};\n' \
    "$TOMTOM_API_KEY" "$API_URL" "$JWT_SECRET_KEY" \
    > src/environments/environment.ts && \
    cp src/environments/environment.ts src/environments/environment.prod.ts

RUN npm run build

# ---- Stage 2: nginx serve ----
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/www /usr/share/nginx/html

EXPOSE 80
