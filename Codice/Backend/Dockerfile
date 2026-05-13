# ---- Stage 1: build & compile TypeScript ----
FROM node:22-bookworm-slim AS builder

WORKDIR /app

ENV PUPPETEER_SKIP_DOWNLOAD=true

COPY package*.json ./
RUN npm ci

COPY . .
RUN npx tsc
# Copia le risorse statiche (immagini, JSON) nella cartella dist mantenendo la struttura
RUN find . -path ./node_modules -prune -o \( -name "*.jpg" -o -name "*.png" -o -name "*.json" \) -print \
    | grep -v node_modules \
    | while read f; do \
        mkdir -p "dist/$(dirname $f)"; \
        cp "$f" "dist/$f"; \
      done

# ---- Stage 2: production image ----
FROM node:22-bookworm-slim

# Chromium e dipendenze runtime per Puppeteer
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-liberation \
    fonts-noto-color-emoji \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    xdg-utils \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV NODE_ENV=production
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Installa solo le dipendenze di produzione
COPY package*.json ./
RUN npm ci --omit=dev

# Copia il compilato TypeScript e le risorse statiche
COPY --from=builder /app/dist ./dist
COPY Assets ./Assets
COPY Email ./Email

# Crea la cartella dati per SQLite (montata come volume)
RUN mkdir -p data

COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]
