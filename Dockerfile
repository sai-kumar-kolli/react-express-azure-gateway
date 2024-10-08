# Step 1: Build the React app
FROM node:16 AS build
WORKDIR /app/client
COPY client/package.json ./
RUN npm install
COPY client ./
RUN npm run build

# Step 2: Set up the Express server
FROM node:16
WORKDIR /app/server
COPY server/package.json ./
RUN npm install
COPY server ./

# Copy only the React build to the Express app
COPY --from=build /app/client/build /app/server/build

# Expose the server port
EXPOSE 5000
CMD ["node", "server.js"]
