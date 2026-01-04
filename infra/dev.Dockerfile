# Use Red Hat Universal Base Image 9 with Python 3.11
FROM registry.access.redhat.com/ubi9/python-311:latest

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Set working directory
WORKDIR /app

# Install system dependencies
USER 0
RUN dnf update -y && \
    dnf install -y \
    gcc \
    gcc-c++ \
    make \
    unixODBC-devel \
    && dnf clean all

# Install Microsoft ODBC Driver for SQL Server
RUN curl https://packages.microsoft.com/config/rhel/9/prod.repo -o /etc/yum.repos.d/mssql-release.repo && \
    ACCEPT_EULA=Y dnf install -y msodbcsql18 && \
    dnf clean all

# Copy requirements file
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy application code
COPY . /app/

# Switch to non-root user for security
USER 1001

# Expose port for Django development server
EXPOSE 8000

# Run Django development server
CMD ["python", "server/manage.py", "runserver", "0.0.0.0:8000"]
