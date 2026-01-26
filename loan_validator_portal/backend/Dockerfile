# Multi-stage build for Loan Validator Portal (Instrumented with OpenTelemetry)
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy all backend files including vendor
COPY . ./

# Build the instrumented application using vendored dependencies
RUN CGO_ENABLED=0 GOOS=linux go build -mod=vendor -o loan-validator-portal main_instrumented.go

# Final stage
FROM alpine:3.18

# Create group and user
RUN addgroup -S loan-validatorgrp \
    && adduser -S loan-validatorusr -G loan-validatorgrp

# Set workdir to /app/backend so ../frontend/templates/* resolves correctly
WORKDIR /app/backend

# Copy the binary from builder
COPY --from=builder --chown=loan-validatorusr:loan-validatorgrp /app/loan-validator-portal .

# Copy templates to /app/frontend/templates/ (relative path ../frontend/templates/* from /app/backend)
COPY --chown=loan-validatorusr:loan-validatorgrp frontend/templates /app/frontend/templates/

# Switch to non-root user
USER loan-validatorusr

# Expose port
EXPOSE 8080

# Run the instrumented application
CMD ["./loan-validator-portal"]