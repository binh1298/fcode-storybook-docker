FROM node:12.18.0-alpine3.9 as build
WORKDIR /tmp
COPY fcode-storybook-backend/package*.json ./
COPY fcode-storybook-backend/tsconfig*.json ./
RUN npm install
COPY fcode-storybook-backend/src ./src
COPY fcode-storybook-backend/.env ./.env
RUN npm run build
FROM build as runner
RUN npm install pm2 -g
WORKDIR /app
COPY --from=build /tmp/node_modules ./node_modules
COPY --from=build /tmp/dist ./dist
COPY fcode-storybook-backend/ecosystem.config.js ./ecosystem.config.js
COPY fcode-storybook-backend/.env ./.env
ENV PORT=4000
EXPOSE 4000
ENTRYPOINT [ "npx","pm2","start","ecosystem.config.js","--no-daemon"]