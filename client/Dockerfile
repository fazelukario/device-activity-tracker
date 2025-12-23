FROM node:20-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code and config
COPY public ./public
COPY src ./src
COPY tsconfig.json ./
COPY tailwind.config.js ./
COPY postcss.config.js ./

# Build argument for API URL
ARG REACT_APP_API_URL=http://localhost:3001
ENV REACT_APP_API_URL=${REACT_APP_API_URL}

# Build the app
RUN npm run build

# Final stage: export build artifacts
FROM alpine:3.23 AS export

RUN apk add --no-cache rsync

COPY --from=build /app/build/ /build/

VOLUME ["/dist"]

# Export build artifacts into a bind-mounted host directory (/dist)
ENTRYPOINT ["rsync", "-a", "--delete", "/build/", "/dist/"]