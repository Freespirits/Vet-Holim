# Build Flutter web bundle
FROM ghcr.io/cirruslabs/flutter:3.19.5 AS builder
WORKDIR /app
COPY pubspec.yaml l10n.yaml analysis_options.yaml ./
COPY lib ./lib
COPY test ./test
RUN flutter pub get
RUN flutter build web --release

# Serve via nginx
FROM nginx:1.27-alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
