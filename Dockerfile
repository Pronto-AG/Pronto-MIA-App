FROM ubuntu:20.04 AS build

# Install dependencies
RUN apt-get update
RUN apt-get install -y bash curl file git unzip xz-utils zip libglu1-mesa
RUN groupadd -r -g 1441 flutter && useradd --no-log-init -r -u 1441 -g flutter -m flutter

# Install sdk
USER flutter:flutter
WORKDIR /home/flutter
RUN git clone https://github.com/flutter/flutter.git -b stable flutter-sdk --depth 1 
RUN flutter-sdk/bin/flutter precache
RUN flutter-sdk/bin/flutter config --no-analytics
ENV PATH="$PATH:/home/flutter/flutter-sdk/bin"
ENV PATH="$PATH:/home/flutter/flutter-sdk/bin/cache/dart-sdk/bin"
RUN flutter doctor

# Copy files
WORKDIR /pronto_mia
COPY pronto_mia/ ./
USER root:root
RUN chown -R flutter:flutter ./
USER flutter:flutter

# Build web
RUN flutter pub get
RUN flutter build web --csp --web-renderer canvaskit

# final stage/image
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html
COPY --from=build /pronto_mia/build/web ./
