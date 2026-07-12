FROM node:18-alpine
WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Expose port (Railway assigns dynamically)
EXPOSE 8080

# Start command
CMD ["node", "src/index.js"]
