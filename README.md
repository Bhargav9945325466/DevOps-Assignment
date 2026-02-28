# DevOps Assignment

This project consists of a FastAPI backend and a Next.js frontend that communicates with the backend.

## Project Structure

```
.
├── backend/               # FastAPI backend
│   ├── app/
│   │   └── main.py       # Main FastAPI application
│   └── requirements.txt    # Python dependencies
└── frontend/              # Next.js frontend
    ├── pages/
    │   └── index.js     # Main page
    ├── public/            # Static files
    └── package.json       # Node.js dependencies
```

## Prerequisites

- Python 3.8+
- Node.js 16+
- npm or yarn

## Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Create a virtual environment (recommended):
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: .\venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Run the FastAPI server:
   ```bash
   uvicorn app.main:app --reload --port 8000
   ```

   The backend will be available at `http://localhost:8000`

## Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   # or
   yarn
   ```

3. Configure the backend URL (if different from default):
   - Open `.env.local`
   - Update `NEXT_PUBLIC_API_URL` with your backend URL
   - Example: `NEXT_PUBLIC_API_URL=https://your-backend-url.com`

4. Run the development server:
   ```bash
   npm run dev
   # or
   yarn dev
   ```

   The frontend will be available at `http://localhost:3000`

## Changing the Backend URL

To change the backend URL that the frontend connects to:

1. Open the `.env.local` file in the frontend directory
2. Update the `NEXT_PUBLIC_API_URL` variable with your new backend URL
3. Save the file
4. Restart the Next.js development server for changes to take effect

Example:
```
NEXT_PUBLIC_API_URL=https://your-new-backend-url.com
```

## For deployment:
   ```bash
   npm run build
   # or
   yarn build
   ```

   AND

   ```bash
   npm run start
   # or
   yarn start
   ```

   The frontend will be available at `http://localhost:3000`

## Testing the Integration

1. Ensure both backend and frontend servers are running
2. Open the frontend in your browser (default: http://localhost:3000)
3. If everything is working correctly, you should see:
   - A status message indicating the backend is connected
   - The message from the backend: "You've successfully integrated the backend!"
   - The current backend URL being used

## API Endpoints

- `GET /api/health`: Health check endpoint
  - Returns: `{"status": "healthy", "message": "Backend is running successfully"}`

- `GET /api/message`: Get the integration message
  - Returns: `{"message": "You've successfully integrated the backend!"}`





________________________________________________________________________________________________________________


Cloud Deployment & Infrastructure

As part of this assignment, the application is deployed using Amazon Web Services (AWS) for the backend and Vercel for the frontend.

Cloud Platforms Used

Amazon Web Services (AWS)
Region: ap-south-1 (Mumbai)

Vercel
Frontend hosting using Vercel Global Edge Network.

The Mumbai region was selected to reduce latency for Indian users and improve backend API response time.

The backend application is containerized using Docker before deployment to ensure portability, consistency, and environment isolation.

Environments
Currently Implemented

Production Environment

A production-ready environment is implemented for this assignment.

The infrastructure is designed in a way that it can be extended to include additional environments such as:

dev (development testing)

staging (pre-production testing)

Each environment can be deployed on separate EC2 instances to avoid configuration conflicts.

Infrastructure Components (AWS Backend)

The backend infrastructure consists of the following AWS services:

1️⃣ Amazon EC2

Amazon EC2 is used to host the backend FastAPI application.

Ubuntu 22.04 LTS is installed

Docker is installed on the EC2 instance

The FastAPI backend runs inside a Docker container

Public IP is used to access the backend

EC2 provides full control over the compute environment and allows container-based deployment.

2️⃣ Amazon ECR (Elastic Container Registry)

Amazon ECR is used to store the Docker image of the backend application.

GitHub Actions builds the Docker image

The image is pushed automatically to ECR

EC2 pulls the image from ECR during deployment

ECR acts as a secure private container registry.

3️⃣ Security Groups

Security Groups act as virtual firewalls for the EC2 instance.

Configured rules:

Port 22 → Allowed from specific IP (for SSH access)

Port 8000 → Allowed for public API access

Security groups ensure controlled and secure infrastructure access.

4️⃣ IAM Role

An IAM role is attached to the EC2 instance.

This allows EC2 to securely pull Docker images from ECR without storing AWS credentials on the server.

This improves security and avoids manual credential management.

CI/CD Implementation

A complete CI/CD pipeline is implemented using GitHub Actions.

Continuous Integration (CI)

On every push to the main branch:

GitHub Actions builds the Docker image.

The image is tagged.

The image is pushed to Amazon ECR.

This ensures every code change creates a fresh deployable container image.

Continuous Deployment (CD)

After the image is pushed to ECR:

EC2 pulls the latest image from ECR.

Existing container is stopped (if running).

A new container is started automatically.

This ensures automatic backend updates without manual SSH deployment.

Verified successfully by modifying the API message and observing automatic production update.

Deployment Process
Step 1 – Dockerize Backend

The FastAPI backend is containerized using Docker.

This ensures consistent behavior across environments.

Step 2 – Push Image to ECR (CI)

GitHub Actions automatically:

Builds Docker image

Tags image

Pushes image to ECR

Step 3 – EC2 Pulls Image (CD)

EC2 pulls the latest Docker image from ECR.

Step 4 – Run Container

The backend container is started using:

docker run -d -p 8000:8000 \
--restart unless-stopped \
--name backend-container \
<ecr-image-url>

Port 8000 is exposed publicly

--restart unless-stopped ensures container auto-restarts on failure

Frontend Deployment (Vercel)

The Next.js frontend is deployed on Vercel.

Features:

Automatic deployment on every GitHub push

Global CDN distribution

Zero server management

To avoid CORS issues, a Vercel rewrite proxy is configured:

async rewrites() {
  return [
    {
      source: "/api/:path*",
      destination: "http://65.2.31.189:8000/:path*",
    },
  ];
}

This ensures the frontend communicates seamlessly with the backend without CORS errors.

Deployment URLs
Backend (AWS EC2)
http://65.2.31.189:8000/docs
Frontend (Vercel)
https://dev-ops-assignment-abq1-1vvvwsu6v-bhargav-ms-projects-bf83b85a.vercel.app/
Networking & Traffic Flow
Frontend Request Flow

User
→ Vercel (Next.js)
→ Vercel Rewrite Proxy
→ EC2 Public IP
→ Docker Container
→ FastAPI
→ Response

Direct Backend Flow

User
→ EC2 Public IP
→ Docker
→ FastAPI

Scalability & Operational Considerations

✔ Docker ensures environment consistency
✔ GitHub Actions enables automated CI/CD
✔ Amazon ECR securely stores images
✔ IAM role improves security
✔ Security Groups restrict unauthorized access
✔ Container auto-restarts on failure
✔ Vercel provides automatic frontend deployment

Conclusion

This architecture demonstrates a production-ready cloud deployment using:

Containerization (Docker)

CI/CD automation (GitHub Actions)

Cloud hosting (AWS EC2)

Container registry (ECR)

Frontend hosting (Vercel)

The pipeline ensures that every code push automatically builds, pushes, and deploys the backend application without manual intervention.