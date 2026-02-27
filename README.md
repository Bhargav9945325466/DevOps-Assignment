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

Amazon Web Services (AWS) – Region: ap-south-1 (Mumbai)

Vercel – Global Edge Network (Frontend Hosting)

The Mumbai region was selected to minimize latency for Indian users and improve backend API response time.

The backend application is containerized using Docker before deployment to ensure portability, consistency, and environment isolation.

Environments

Currently implemented:

Production Environment

For this assignment, a production-ready deployment is implemented.
The architecture is designed in a way that it can be extended to dev and staging environments in the future by provisioning separate EC2 instances and load balancers.

Future improvements:

dev – minimal resources for development testing

staging – pre-production testing environment

Each environment would ideally maintain separate infrastructure to avoid configuration conflicts.

Infrastructure Components (AWS Backend)

The following AWS services are used:

1. Amazon EC2

Used to run the backend FastAPI application inside a Docker container.

EC2 provides full control over the compute environment and allows Docker-based deployments.

2. Amazon ECR (Elastic Container Registry)

Stores the Docker image of the backend application.

ECR acts as a secure container registry from which EC2 pulls the backend image.

3. Application Load Balancer (ALB)

Routes incoming HTTP traffic to the EC2 instance.

ALB improves scalability and allows future horizontal scaling by attaching multiple EC2 instances.
It also prevents direct exposure of the EC2 instance.

4. Security Groups

Used as virtual firewalls.

Port 22 → Allowed only from specific IP (SSH access)

Port 80 → Allowed for HTTP traffic via ALB

Security groups ensure controlled and secure access to infrastructure.

5. IAM Role

Attached to EC2 instance.

Allows EC2 to securely pull Docker images from ECR without storing credentials manually.

Deployment Process
Step 1 – Dockerize Backend

The FastAPI backend is containerized using Docker.

This ensures consistent deployment across environments.

Step 2 – Push Image to ECR

Docker image is tagged and pushed to Amazon ECR.

Step 3 – EC2 Pulls Image

EC2 instance pulls the Docker image from ECR.

Step 4 – Run Container

The container is started using:

docker run -d -p 80:8000 \
--restart unless-stopped \
--name backend-container \
<ecr-image-url>

Port 8000 is internal to the container.
Port 80 is exposed publicly.
--restart unless-stopped ensures high availability.

Step 5 – ALB Routing

ALB forwards incoming requests to EC2 instance.

Step 6 – Frontend Deployment (Vercel)

The Next.js frontend is deployed on Vercel.

Vercel automatically builds and deploys the frontend on every GitHub push.

To avoid CORS issues, Vercel rewrite proxy is used:

async rewrites() {
  return [
    {
      source: "/api/:path*",
      destination: "http://backend-alb-1074945613.ap-south-1.elb.amazonaws.com/:path*",
    },
  ];
}

This ensures the frontend communicates securely with the backend via ALB.

Deployment URLs
Backend (AWS ALB)

http://backend-alb-1074945613.ap-south-1.elb.amazonaws.com/docs

Frontend (Vercel)

https://dev-ops-assignment-abq1-1wwwsu6v-bhargav-ms-projects-bf83b85a.vercel.app/

Networking & Traffic Flow

The networking design ensures separation of concerns and controlled public exposure.

Traffic Flow Diagram

Frontend Flow:

User
→ Vercel (Next.js)
→ Vercel Rewrite Proxy
→ AWS ALB
→ EC2
→ Docker Container
→ FastAPI
→ Response

Direct Backend Flow:

User
→ ALB
→ EC2
→ Docker
→ FastAPI

Scalability & Operational Considerations

✔ Docker ensures environment consistency
✔ ALB enables horizontal scaling
✔ EC2 IAM role improves security
✔ Security Groups restrict access
✔ Vercel provides automatic frontend deployment
✔ Container auto-restarts on failure
