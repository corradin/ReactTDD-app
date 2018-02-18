FROM node:9 as build
WORKDIR /ReactTDD-app

# Xvfb
RUN apt-get update -qqy \
	&& apt-get -qqy install xvfb \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update -qqy \
	&& apt-get -qqy install google-chrome-stable \
	&& rm /etc/apt/sources.list.d/google-chrome.list \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
	&& sed -i 's/"$HERE\/chrome"/xvfb-run "$HERE\/chrome" --no-sandbox/g' /opt/google/chrome/google-chrome

#Vim
RUN apt-get update -qqy \
    && apt-get -qqy install vim

COPY package.json /ReactTDD-app
RUN npm install

COPY . /ReactTDD-app

#Replace a setting in the Karma test runner to only run once 
#Set CI to true in order to run the tests only once, see: https://github.com/facebook/create-react-app/issues/784
ENV CI=true 
RUN npm test && npm run build

#Using multi-stage builds to keep images small and separate build from deployment
FROM alpine:3.7 as deploy

RUN apk --update add nginx && \
    mkdir -p /run/nginx

COPY --from=build /ReactTDD-app/build/ /build/
ADD nginx.conf /etc/nginx/

ENV LISTEN_PORT=80

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]