# Production Dockerfile with Apache HTTP Server
# Use Red Hat Universal Base Image 9 with Python 3.11
FROM registry.access.redhat.com/ubi9/python-311:latest

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    MODE=prod \
    DEBUG=False

# Set working directory
WORKDIR /app

# Install system dependencies including Apache and mod_wsgi
USER 0
RUN dnf update -y && \
    dnf install -y \
    gcc \
    gcc-c++ \
    make \
    unixODBC-devel \
    httpd \
    httpd-devel \
    python3.11-devel \
    && dnf clean all

# Install Microsoft ODBC Driver for SQL Server
RUN curl https://packages.microsoft.com/config/rhel/9/prod.repo -o /etc/yum.repos.d/mssql-release.repo && \
    ACCEPT_EULA=Y dnf install -y msodbcsql18 && \
    dnf clean all

# Copy requirements file
COPY requirements.txt /app/

# Install Python dependencies including mod_wsgi
RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip install mod_wsgi

# Copy application code
COPY . /app/

# Create static files directory and collect static files
RUN mkdir -p /app/staticfiles && \
    chown -R 1001:0 /app/staticfiles && \
    chmod -R g=u /app/staticfiles

# Generate mod_wsgi Apache configuration
RUN mod_wsgi-express module-config > /etc/httpd/conf.modules.d/02-wsgi.conf

# Copy Apache configuration
COPY infra/apache-config.conf /etc/httpd/conf.d/django.conf

# Set proper permissions for Apache
RUN chown -R 1001:0 /app && \
    chmod -R g=u /app && \
    chown -R 1001:0 /var/log/httpd && \
    chmod -R g=u /var/log/httpd && \
    chown -R 1001:0 /run/httpd && \
    chmod -R g=u /run/httpd

# Expose port 8080 (non-privileged port)
EXPOSE 8080

# Switch to non-root user for security
USER 1001

# Collect static files at build time
RUN python server/manage.py collectstatic --noinput

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Run Apache in foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
