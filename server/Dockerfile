# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json tsconfig.json jest.config.cjs ./
COPY src ./src
COPY tests ./tests
RUN npm install --production=false && npm run build

# Runtime stage
FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
EXPOSE 4000
CMD ["node", "dist/index.js"]
