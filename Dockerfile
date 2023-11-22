# Dockerfile
FROM node:14 as build

WORKDIR /app

# Install and build Angular frontend
COPY Frontend/package*.json ./
RUN npm install
COPY Frontend .
RUN npm run build

# Switch to a new base image for Python backend
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8

# Copy Angular build output to Python app directory
COPY --from=build /app/dist /app/static

# Copy and install Python dependencies
COPY Backend /app

# Expose port
EXPOSE 80

# Start FastAPI server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
