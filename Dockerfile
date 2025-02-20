#Base image for building
FROM node:20-alpine As builder
# Set up the working directory
WORKDIR /app
# Copy package.json and package-lock.json
COPY package*.json ./
#Install dependencies
RUN npm install
#Copy the rest of the application file from the repository                                            COPY . .
#Convert the development files to static serving files
RUN npm run build

#Production Image
FROM node:20-alpine As runner
#Set up the working directory
WORKDIR /app
#Copy the builder files from builder image
COPY --from=builder /app/dist ./dist
#Install a lightweight server to serve the static files previously created
RUN npm install -g serve
#Expose the port
EXPOSE 3000
#Start the application using serve
CMD ["serve", "-s", "dist", "-1", "3000"] 
