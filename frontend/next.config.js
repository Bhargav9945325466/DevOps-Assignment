/** @type {import('next').NextConfig} */
const nextConfig = {
  async rewrites() {
    return [
      {
        source: "/api/:path*",
        destination: "http://backend-alb-1074945613.ap-south-1.elb.amazonaws.com/:path*",
      },
    ];
  },
};

module.exports = nextConfig;