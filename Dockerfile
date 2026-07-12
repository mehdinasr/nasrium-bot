FROM node:18-alpine
WORKDIR /app

# Copy package files from root
COPY package*.json ./
RUN npm install

# Copy source files
COPY bot/src ./src
COPY bot/.env ./.env

# Expose port
EXPOSE 8080

# Start command
CMD ["node", "src/index.js"]
