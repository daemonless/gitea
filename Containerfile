# NOTE: Gitea no longer provides FreeBSD binary releases as of v1.25.x
# Use Containerfile.pkg (gitea:pkg) which uses the FreeBSD package
# This file is kept for documentation purposes and potential future builds from source

ARG BASE_VERSION=15
FROM ghcr.io/daemonless/base:${BASE_VERSION}

ARG FREEBSD_ARCH=amd64
LABEL org.opencontainers.image.title="gitea" \
      org.opencontainers.image.description="Gitea self-hosted Git service on FreeBSD" \
      org.opencontainers.image.source="https://github.com/daemonless/gitea" \
      org.opencontainers.image.url="https://about.gitea.com/" \
      org.opencontainers.image.documentation="https://docs.gitea.com/" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.vendor="daemonless" \
      org.opencontainers.image.authors="daemonless" \
      io.daemonless.port="3000" \
      io.daemonless.arch="${FREEBSD_ARCH}" \
      io.daemonless.config-mount="/config" \
      io.daemonless.pkg-source="containerfile"

# Install Gitea from FreeBSD packages (pkg handles all dependencies)
RUN pkg update && \
    pkg install -y gitea && \
    pkg clean -ay && \
    rm -rf /var/cache/pkg/* /var/db/pkg/repos/*

# Create version info
RUN GITEA_VERSION=$(pkg info gitea | sed -n 's/.*Version.*: *//p') && \
    printf "Version: %s\nPackageAuthor: [daemonless](https://github.com/daemonless/daemonless)\n" "$GITEA_VERSION" > /usr/local/share/gitea/version_info && \
    mkdir -p /app && echo "$GITEA_VERSION" > /app/version

# Create required directories
RUN mkdir -p /config/data /config/custom/conf /config/repos /config/log /config/lfs /config/tmp && \
    chown -R bsd:bsd /config

# Copy service definition and init scripts
COPY root/ /

# Make scripts executable
RUN chmod +x /etc/services.d/gitea/run /etc/cont-init.d/* 2>/dev/null || true

# Set up s6 service link

EXPOSE 3000 22
VOLUME /config


