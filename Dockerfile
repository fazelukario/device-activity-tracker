FROM node:20-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (ignore postinstall script that tries to install client deps)
RUN npm install --ignore-scripts

# Copy source code and config
COPY tsconfig.json ./
COPY src ./src

# Build TypeScript
RUN npm run build


FROM node:20-alpine AS runtime

WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev --ignore-scripts

COPY --from=build /app/dist ./dist

# Persist Baileys multi-file auth state
ARG BAILEYS_AUTH_DIR=baileys_auth_info
ENV BAILEYS_AUTH_DIR=${BAILEYS_AUTH_DIR}
RUN mkdir -p "/app/${BAILEYS_AUTH_DIR}"

# Expose port (can be overridden by environment variable)
ARG EXPOSE_PORT=3001
ENV PORT=${EXPOSE_PORT}
EXPOSE ${EXPOSE_PORT}

CMD ["node", "dist/server.js"]