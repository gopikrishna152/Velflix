# Stage 1: Build Stage
FROM node:14.19.1 AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json ./
COPY package-lock.json ./

# Install dependencies, including 'has'
RUN npm install has

# Install all other dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Production Stage
FROM node:14.19.1-slim

# Set the working directory
WORKDIR /app

# Copy only the built files from the builder stage
COPY --from=builder /app .

# Ensure all dependencies for production
RUN npm install --only=production

# Expose port
EXPOSE 3000

# Run the development server
CMD ["npm", "run", "dev", "--", "--host"]

