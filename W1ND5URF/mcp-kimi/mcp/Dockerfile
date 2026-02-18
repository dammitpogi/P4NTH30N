FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY tsconfig.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY src ./src

# Build TypeScript
RUN npm run build

# Set environment variables (will be overridden by ToolHive)
ENV KIMI_API_KEY=""
ENV KIMI_BASE_URL="https://api.kimi.com/coding"
ENV NODE_ENV=production

# Expose port (if using HTTP transport, stdio is default)
# EXPOSE 3000

# Run the MCP server
CMD ["node", "dist/index.js"]
