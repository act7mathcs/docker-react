# This file is located at: Desktop/Aarons_Folder/Web_Dev/Docker/frontend.

# This is the Dockerfile for the production environment. This uses a multi-step process where we create the first container layer and execute some commands; then from that layer we copy only a few things over (specifically, what's in app/build) to the second layer and drop the rest (since the rest is for development).

# We build this image with: docker build . (note the .). To run the container, we type (since this is a web app, we use port mapping to get access): docker run -p 8080:80 <image id>.

# We tag this phase with the name 'builder'. That means everything from the FROM command will be referred to as the builder phase. The output of all of this (the build folder) will be created in the working directory.
FROM node:alpine as builder
WORKDIR /app
# We don't implement the volume system because we don't change our code in the production environment.
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# The below is the run phase. We don't have to specify this phase because the second FROM statement indicates this.
FROM nginx
# The --from=builder indicates we're copying from the builder phase. We're copying from the folder /app/build to /usr/share/nginx/html (we got this url from the nginx documentation).
COPY --from=builder /app/build /usr/share/nginx/html



