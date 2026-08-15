FROM node:22-bookworm-slim

RUN apt-get update \
  && apt-get install --no-install-recommends -y python3 make g++ \
  && rm -rf /var/lib/apt/lists/*

RUN npm install --global @letta-ai/letta-code

WORKDIR /data
EXPOSE 4500
CMD ["letta", "server", "--backend", "local", "--listen", "ws://0.0.0.0:4500"]
