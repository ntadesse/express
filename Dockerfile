# Use an official Node.js runtime as a parent image
FROM node:18-alpine3.17

# Set the working directory in the container to /app
WORKDIR /usr/app

# Copy the package*.json files to the working directory
COPY package*.json ./usr/app/

# Install the dependencies
RUN npm install

# Copy the application code to the working directory
COPY . .

# Make port 80 available to the world outside this container
EXPOSE 3000

# Define environment variable
ENV MONGO_URI=uriPlaceholder
ENV MONGO_USERNAME=usernamePlaceholder
ENV MONGO_PASSWORD=passwordPlaceholder

# Run app.js when the container launches
CMD ["npm", "start"]
