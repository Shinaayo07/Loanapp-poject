# Multi-stage build for Government API
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy everything including vendor directory
COPY . ./

# Build the application using vendored dependencies
RUN CGO_ENABLED=0 GOOS=linux go build -mod=vendor -o government-api .

# Final stage
FROM alpine:3.18

# Create group and user
RUN addgroup -S governmentgrp \
    && adduser -S governmentusr -G governmentgrp

# Set working directory
WORKDIR /app

# Copy the binary from builder
COPY --from=builder --chown=governmentusr:governmentgrp /app/government-api .

# Switch to non-root user
USER governmentusr

# Expose port
EXPOSE 8081

# Run the application
CMD ["./government-api"]