# Global ARG must be declared before first FROM to be usable in FROM instructions
ARG BUILD_FROM

# ──────────────────────────────────────────────
# Stage 1: Build the fat JAR with Maven
# Source is copied into context by GitHub Actions (CI) or build-local.sh (local dev)
# ──────────────────────────────────────────────
FROM --platform=linux/amd64 maven:3.9-eclipse-temurin-17-alpine AS builder

WORKDIR /build

# Copy dependency manifest first for better layer caching
COPY pom.xml .
RUN mvn dependency:go-offline -q

# Copy source and build
COPY src/ src/
RUN mvn clean package -DskipTests -q

# ──────────────────────────────────────────────
# Stage 2: Runtime image (Home Assistant base)
# ──────────────────────────────────────────────
FROM $BUILD_FROM

# Install a minimal JRE
RUN apk add --no-cache openjdk17-jre-headless

WORKDIR /app

# Copy the fat JAR produced by the builder stage
COPY --from=builder /build/target/MajordomusControl-jar-with-dependencies.jar app.jar

# Copy and prepare the start-up script
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
