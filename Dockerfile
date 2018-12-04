FROM node:8

LABEL maintainer="andrey.mikhalchuk@conceptant.com"
LABEL version="0.1.0"
LABEL description="This Dockerfile builds Healthy Citizen Widget Manager Demonstration Site"
LABEL "com.conceptant.vendor"="Conceptant, Inc."

RUN git clone https://github.com/FDA/Healthy-Citizen-Code.git && mv Healthy-Citizen-Code hc
WORKDIR hc
COPY files/start.sh .
COPY files/example.env adp-backend-v5/.env
COPY files/example.api_config.json adp-frontend-web-v4/api_config.json
RUN npm i -g bower
RUN cd adp-backend-v5 && \
    npm i
RUN cd adp-frontend-web-v4 && \
    npm i && \
    echo '{ "allow_root": true }' > /root/.bowerrc && \
    bower i && \
    npm run build
RUN cd widget-manager && \
    npm i

ENV APP_PORT=8000
ENV APP_HOST=localhost
ENV APP_PROTO=https
ENV JWT_SECRET="sample-jwt-secret-20181119"
ENV APP_ID="widget-manager-20181119"
ENV MONGODB_HOST=mongodb
ENV MONGODB_PORT=27017
ENV APP_URL="https://healthy:citizen!@widget-manager-backend.conceptant.com"

USER root
CMD ["./start.sh"]
ENTRYPOINT "./start.sh"
EXPOSE 8080

