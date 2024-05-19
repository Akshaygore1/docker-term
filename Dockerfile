



FROM ubuntu:focal

# Install curl and other necessary packages
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js LTS version
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install other necessary packages for building Node.js modules
RUN apt-get update && \
    apt-get install -y g++ make python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose the port your application is listening on
EXPOSE 8080

# Set the working directory
WORKDIR /home/app

# Copy the necessary files
COPY . /home/app
COPY package.json .
COPY user /home/app/user

# Install dependencies
RUN npm install

# Specify the command to run the application
CMD [ "node", "index.js" ]
