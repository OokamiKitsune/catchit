# Base image with Node.js and Python
FROM node:20-alpine AS builder

# Install Python (for yt-dlp)
RUN apk add --no-cache python3 py3-pip

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy the rest of the app's code
COPY . .

# Build the Next.js app
RUN yarn build

# -----------------------------------------
# Create a lightweight runtime container
# -----------------------------------------
FROM node:20-alpine

# Install Python in the runtime container
RUN apk add --no-cache python3 py3-pip

# Set working directory
WORKDIR /app

# Copy built files from builder stage
COPY --from=builder /app ./

# Install only production dependencies
RUN yarn install --frozen-lockfile --production

# Expose the port Next.js runs on
EXPOSE 3000

# Start the Next.js app
CMD ["yarn", "start"]