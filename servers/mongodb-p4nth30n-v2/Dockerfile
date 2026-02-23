FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY vendor ./vendor
RUN npm install

COPY src ./src
COPY tsconfig.json ./
RUN npm run build

FROM node:20-alpine AS production

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/vendor ./vendor
COPY package*.json ./

RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
USER nodejs

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD wget --header='Origin: http://localhost:5173' --no-verbose --tries=1 --spider http://localhost:3001/health || exit 1

ENV PORT=3001
ENV BIND_ADDRESS=127.0.0.1

EXPOSE 3001

CMD ["node", "dist/index.js"]
