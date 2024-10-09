# **README for Azure Web App and Application Gateway Setup with Dockerized React and Express**

## **Table of Contents**

- [**README for Azure Web App and Application Gateway Setup with Dockerized React and Express**](#readme-for-azure-web-app-and-application-gateway-setup-with-dockerized-react-and-express)
  - [**Table of Contents**](#table-of-contents)
  - [**1. Project Overview**](#1-project-overview)
  - [**2. Architecture Overview**](#2-architecture-overview)
  - [**3. Technology Stack**](#3-technology-stack)
  - [**4. Application Gateway Detailed Components**](#4-application-gateway-detailed-components)
    - [**4.1 Frontend IP Configuration**](#41-frontend-ip-configuration)
      - [**When to use Public vs Private IP?**](#when-to-use-public-vs-private-ip)
    - [**4.2 Listeners**](#42-listeners)
      - [**4.2.1 What are Listeners?**](#421-what-are-listeners)
      - [**4.2.2 Types of Listeners**](#422-types-of-listeners)
      - [**4.2.3 How to Configure Listeners**](#423-how-to-configure-listeners)
    - [**4.3 Backend Pools**](#43-backend-pools)
      - [**4.3.1 Backend Pool Explanation**](#431-backend-pool-explanation)
      - [**4.3.2 How Backend Pools Work**](#432-how-backend-pools-work)
      - [**4.3.3 Configuring Backend Pools**](#433-configuring-backend-pools)
    - [**4.4 HTTP Settings**](#44-http-settings)
      - [**4.4.1 Session Affinity Explained**](#441-session-affinity-explained)
      - [**4.4.2 Timeout and Protocol Settings**](#442-timeout-and-protocol-settings)
      - [**4.4.3 SSL Termination**](#443-ssl-termination)
      - [**4.4.4 How to Configure HTTP Settings**](#444-how-to-configure-http-settings)
    - [**4.5 Health Probes**](#45-health-probes)
      - [**4.5.1 Why Health Probes Matter**](#451-why-health-probes-matter)
      - [**4.5.2 Configuring Health Probes**](#452-configuring-health-probes)
    - [**4.6 Request Routing Rules**](#46-request-routing-rules)
      - [**4.6.1 Path-based Routing**](#461-path-based-routing)
      - [**4.6.2 Host-based Routing (cont.)**](#462-host-based-routing-cont)
  - [**5. Traffic Flow Explanation**](#5-traffic-flow-explanation)
    - [**Step-by-Step Traffic Flow**](#step-by-step-traffic-flow)
  - [**6. Deployment Steps**](#6-deployment-steps)
    - [**6.1 Building and Dockerizing the Application**](#61-building-and-dockerizing-the-application)
    - [**6.2 Pushing to Docker Hub**](#62-pushing-to-docker-hub)
    - [**6.3 Deploying to Azure Web App**](#63-deploying-to-azure-web-app)
    - [**6.4 Setting Up Application Gateway**](#64-setting-up-application-gateway)
      - [**6.4.1 Creating an Application Gateway**](#641-creating-an-application-gateway)
      - [**6.4.2 Configuring Components**](#642-configuring-components)
  - [**7. Common Issues and Troubleshooting**](#7-common-issues-and-troubleshooting)
    - [**7.1 502 Bad Gateway Errors**](#71-502-bad-gateway-errors)
    - [**7.2 Unhealthy Backend Pools**](#72-unhealthy-backend-pools)
  - [**8. Best Practices for Application Gateway and Web App**](#8-best-practices-for-application-gateway-and-web-app)
    - [**8.1 Autoscaling**](#81-autoscaling)
    - [**8.2 Security Best Practices**](#82-security-best-practices)
    - [**8.3 Monitoring and Logs**](#83-monitoring-and-logs)
  - [**9.0 Sample YML file**](#90-sample-yml-file)
  - [**10. Suffix Changes Deployment for `/app` Path**](#10-suffix-changes-deployment-for-app-path)
    - [**10.1 Modifying the Express Server**](#101-modifying-the-express-server)
      - [**Express Server Configuration**:](#express-server-configuration)
    - [**10.2 Adjusting the React App**](#102-adjusting-the-react-app)
      - [**Set Homepage in `package.json`**:](#set-homepage-in-packagejson)
      - [**Adjust React Router** (If applicable):](#adjust-react-router-if-applicable)
    - [**10.3 Configuring Azure Web App for `/app` Path**](#103-configuring-azure-web-app-for-app-path)
    - [**10.4 Configuring Application Gateway for `/app` Path**](#104-configuring-application-gateway-for-app-path)
      - [**1. Reuse Existing Backend Pool**:](#1-reuse-existing-backend-pool)
      - [**2. Create a Path-Based Routing Rule for `/app`**:](#2-create-a-path-based-routing-rule-for-app)
      - [**Example Routing Rule**:](#example-routing-rule)
    - [**10.5 Dockerfile Adjustments for `/app` Path**](#105-dockerfile-adjustments-for-app-path)
  - [**Conclusion**](#conclusion)

## **1. Project Overview**

This project involves building a full-stack web application using **React** for the frontend and **Express.js** as the backend. The application is packaged into a **Docker container** and deployed to **Azure Web App**. Traffic is routed and managed by an **Azure Application Gateway**, which provides load balancing, security, and advanced routing capabilities.

---

## **2. Architecture Overview**

The architecture uses Azure’s fully managed services to provide scalability and reliability. Below is a simplified visual representation:

```plaintext
+---------------------------+
|         User               |
+---------------------------+
            |
    +--------------------+
    | Application Gateway |
    +--------------------+
            |
+----------------------------+
|    Azure Web App (Docker)   |
+----------------------------+
            |
+----------------------------+
|  React + Express Container  |
+----------------------------+
```

---

## **3. Technology Stack**

- **Frontend**: React.js
- **Backend**: Express.js (serving static files)
- **Containerization**: Docker
- **Cloud Hosting**: Azure Web App with Docker
- **Traffic Management**: Azure Application Gateway

---

## **4. Application Gateway Detailed Components**

Azure Application Gateway consists of various components that work together to manage and route traffic to your application.

### **4.1 Frontend IP Configuration**

The **Frontend IP Configuration** determines how the Application Gateway listens for incoming traffic.

- **Public IP**: Used for internet-facing applications. The user accesses the application through this IP.
- **Private IP**: For internal applications accessed within a Virtual Network.

#### **When to use Public vs Private IP?**

- **Public IP**: If your application is public-facing and needs to be accessed from the internet.
- **Private IP**: For internal applications within a company’s network (for example, intranet applications).

### **4.2 Listeners**

#### **4.2.1 What are Listeners?**

Listeners are responsible for listening to incoming traffic on specific ports (e.g., HTTP or HTTPS). The listener helps the Application Gateway determine which traffic to accept and where to send it.

#### **4.2.2 Types of Listeners**

- **HTTP Listener**: Listens for HTTP requests on port 80.
- **HTTPS Listener**: Listens for HTTPS requests on port 443 (requires an SSL certificate for decryption).

#### **4.2.3 How to Configure Listeners**

- In the Azure Portal, go to **Application Gateway**.
- Select **Listeners** from the configuration menu.
- Define a new listener with the desired port and protocol.
- For HTTPS, upload an SSL certificate.

---

### **4.3 Backend Pools**

#### **4.3.1 Backend Pool Explanation**

A **Backend Pool** defines the servers (e.g., Web Apps, Virtual Machines) to which traffic is routed after being processed by the Application Gateway.

#### **4.3.2 How Backend Pools Work**

The backend pool distributes traffic to the servers based on routing rules. It can contain multiple instances, and traffic is balanced across these instances.

#### **4.3.3 Configuring Backend Pools**

- Go to the **Backend Pools** section in your Application Gateway.
- Define your **Azure Web App** or other servers (VMs, Scale Sets) in the pool.
- Enter the **FQDN** (Fully Qualified Domain Name) of your backend servers (e.g., `yourapp.azurewebsites.net`).

---

### **4.4 HTTP Settings**

HTTP settings define how traffic is sent to the backend pool.

#### **4.4.1 Session Affinity Explained**

**Session Affinity** ensures that a user is routed to the same backend server for the duration of their session. This is achieved by using cookies that store session data.

- **Why Necessary**: This is useful in stateful applications like shopping carts, where users need to remain on the same server to maintain their session data.

#### **4.4.2 Timeout and Protocol Settings**

- **Timeout**: Defines how long the Application Gateway waits for a response from the backend before considering the request failed.
- **Protocol**: Specifies whether traffic should be sent over **HTTP** or **HTTPS**.

#### **4.4.3 SSL Termination**

SSL termination allows the Application Gateway to handle SSL decryption at the frontend and forward unencrypted traffic to the backend.

- **Why Useful**: Reduces the load on backend servers by handling SSL offloading at the Application Gateway.

#### **4.4.4 How to Configure HTTP Settings**

- Go to the **HTTP Settings** section of the Application Gateway.
- Configure the **Timeout** settings based on your application’s needs.
- Enable **Session Affinity** if your application requires session persistence.

---

### **4.5 Health Probes**

Health probes monitor the status of backend servers to ensure they are available and healthy.

#### **4.5.1 Why Health Probes Matter**

Health probes periodically check the backend servers by sending HTTP requests. If a backend server fails multiple probes, it is marked as unhealthy, and traffic is stopped from being routed to it.

#### **4.5.2 Configuring Health Probes**

- Set up health probes in the **Probes** section.
- Define a **path** that the probe will hit (e.g., `/health`).
- Specify how often the probe runs and the timeout period.

---

### **4.6 Request Routing Rules**

Request routing rules define how traffic is routed from the frontend listener to the backend pool.

#### **4.6.1 Path-based Routing**

**Path-based routing** allows routing traffic to different backends based on the request URL (e.g., `/api` routes to one backend, `/web` routes to another).

#### **4.6.2 Host-based Routing (cont.)**

**Host-based routing** routes traffic based on the hostname (e.g., `api.example.com` routes to one backend pool, while `web.example.com` routes to a different backend pool).

**When to Use Path-based or Host-based Routing?**

- **Path-based Routing**: When you need to route different parts of your application (like a front end and an API) to different backends. For example, `/api/*` goes to the API server, and `/web/*` goes to the frontend.
- **Host-based Routing**: When you host multiple subdomains or domains that need to go to different backend servers. For example, `blog.example.com` and `shop.example.com` route to different services.

---

## **5. Traffic Flow Explanation**

Here’s a visual breakdown of how traffic flows through the system when a user accesses your application:

```plaintext
User Request (HTTP/HTTPS) --> Application Gateway Listener -->
Routing Rule (Path or Host) --> Backend Pool (Web App) -->
HTTP Settings (Timeout, Affinity) --> Health Probes Check -->
Response Sent Back via Application Gateway to User
```

### **Step-by-Step Traffic Flow**

1. **User Request**: A user enters the website URL, and the browser sends an HTTP/HTTPS request.
2. **Frontend IP**: The request is directed to the public IP address of the Azure Application Gateway.
3. **Listener**: The listener captures the request based on the port (HTTP: 80, HTTPS: 443).
4. **Routing Rule**: The rule routes the traffic to the appropriate backend based on URL path or hostname.
5. **Backend Pool**: The selected backend pool distributes the request to one of the healthy backend servers.
6. **HTTP Settings**: The request is processed based on the defined HTTP settings (such as protocol, affinity, or timeout).
7. **Health Probes**: Before forwarding the traffic, the gateway checks if the backend server is healthy.
8. **Response**: The response is processed by the backend server and sent back to the user via the Application Gateway.

---

## **6. Deployment Steps**

This section will cover how to deploy your application using Docker, push it to Docker Hub, deploy to Azure Web App, and configure the Application Gateway.

### **6.1 Building and Dockerizing the Application**

- **React (Frontend)** and **Express (Backend)** are combined into a single Docker container.
- The `Dockerfile` uses a multi-stage build to separate the build and runtime phases.

**Steps**:

1. Navigate to your project root.
2. Build the Docker image for the combined React + Express application:
   ```bash
   docker build -t <your-dockerhub-username>/my-fullstack-app .
   ```
3. Verify that the Docker image is created:
   ```bash
   docker images
   ```

### **6.2 Pushing to Docker Hub**

1. **Log in** to Docker Hub:
   ```bash
   docker login
   ```
2. **Push the Docker image**:
   ```bash
   docker push <your-dockerhub-username>/my-fullstack-app
   ```

### **6.3 Deploying to Azure Web App**

1. **Create an Azure Web App**:
   - In the Azure portal, go to **Create a Resource** and select **Web App**.
   - Choose **Docker** as the operating environment.
2. **Configure the Web App**:
   - Select **Docker Hub** as the container registry.
   - Enter the name of your image (e.g., `<your-dockerhub-username>/my-fullstack-app`).
   - Click **Create**.

### **6.4 Setting Up Application Gateway**

#### **6.4.1 Creating an Application Gateway**

1. In the **Azure Portal**, go to **Create a Resource** and search for **Application Gateway**.
2. Select **Create** and fill in the required fields, including:
   - **Subscription** and **Resource Group**.
   - **Region**: The region where you want to deploy the Application Gateway.
   - **Tier**: Choose `Standard_v2` or `WAF_v2` if Web Application Firewall is needed.

#### **6.4.2 Configuring Components**

1. **Frontend IP**: Choose whether your gateway will have a **Public** or **Private** IP.
2. **Listener**: Create a listener for HTTP (port 80) or HTTPS (port 443), based on your requirement.
3. **Backend Pool**: Add your Azure Web App (or other resources) as part of the backend pool.
4. **HTTP Settings**: Configure how traffic is forwarded to the backend pool, enable session affinity, and set timeouts.
5. **Health Probes**: Create health probes to monitor the status of backend servers.
6. **Request Routing Rules**: Define rules to route traffic based on the URL path or host.

---

## **7. Common Issues and Troubleshooting**

### **7.1 502 Bad Gateway Errors**

- **Cause**: This usually occurs when the backend server is unavailable or misconfigured.
- **Solution**:
  - Ensure that the backend servers in the pool are healthy.
  - Verify the health probe configuration.
  - Ensure the backend server can be accessed from the Application Gateway.

### **7.2 Unhealthy Backend Pools**

- **Cause**: The health probe fails due to an incorrect path or an unresponsive backend server.
- **Solution**:
  - Check the probe path (ensure it’s reachable, e.g., `/health` or `/`).
  - Ensure the backend service returns a `200 OK` response.

---

## **8. Best Practices for Application Gateway and Web App**

### **8.1 Autoscaling**

- Enable autoscaling for the Application Gateway to handle traffic spikes.
- Autoscale your Azure Web App based on traffic to ensure availability during peak loads.

### **8.2 Security Best Practices**

- **SSL Termination**: Offload SSL decryption at the Application Gateway to reduce the load on backend servers.
- **Enable HTTPS**: Force HTTPS traffic to ensure secure communication between the user and the Application Gateway.

### **8.3 Monitoring and Logs**

- **Enable Diagnostics**: Enable Application Gateway diagnostic logs to track performance and troubleshoot issues.
- **Azure Monitor**: Use Azure Monitor to observe traffic patterns, health probe failures, and overall application performance.

---

## **9.0 Sample YML file**

```yml
  $schema: "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"
contentVersion: "1.0.0.0"
parameters:
  applicationGateways_azure_app_name:
    defaultValue: "PLACEHOLDER_FOR_APP_GATEWAY_NAME"
    type: String
  virtualNetworks_azure_app_vnet_externalid:
    defaultValue: "/subscriptions/PLACEHOLDER_FOR_SUBSCRIPTION_ID/resourceGroups/PLACEHOLDER_FOR_RESOURCE_GROUP/providers/Microsoft.Network/virtualNetworks/PLACEHOLDER_FOR_VNET_NAME"
    type: String
  publicIPAddresses_azure_app_myip_externalid:
    defaultValue: "/subscriptions/PLACEHOLDER_FOR_SUBSCRIPTION_ID/resourceGroups/PLACEHOLDER_FOR_RESOURCE_GROUP/providers/Microsoft.Network/publicIPAddresses/PLACEHOLDER_FOR_PUBLIC_IP_NAME"
    type: String
variables: {}
resources:
  - type: Microsoft.Network/applicationGateways
    apiVersion: 2024-01-01
    name: "[parameters('applicationGateways_azure_app_name')]"
    location: southcentralus
    zones:
      - 1
      - 2
      - 3
    properties:
      sku:
        name: Standard_v2
        tier: Standard_v2
        family: Generation_1
      gatewayIPConfigurations:
        - name: appGatewayIpConfig
          id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), '/gatewayIPConfigurations/appGatewayIpConfig')]"
          properties:
            subnet:
              id: "[concat(parameters('virtualNetworks_azure_app_vnet_externalid'), '/subnets/default')]"
      frontendIPConfigurations:
        - name: appGwPublicFrontendIpIPv4
          id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), '/frontendIPConfigurations/appGwPublicFrontendIpIPv4')]"
          properties:
            privateIPAllocationMethod: Dynamic
            publicIPAddress:
              id: "[parameters('publicIPAddresses_azure_app_myip_externalid')]"
      frontendPorts:
        - name: port_80
          id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), '/frontendPorts/port_80')]"
          properties:
            port: 80
      backendAddressPools:
        - name: "[concat(parameters('applicationGateways_azure_app_name'), '-mybe')]"
          id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), concat('/backendAddressPools/', parameters('applicationGateways_azure_app_name'), '-mybe'))]"
          properties:
            backendAddresses:
              - fqdn: WEBAPP_NAME.azurewebsites.net
      backendHttpSettingsCollection:
        - name: "[concat(parameters('applicationGateways_azure_app_name'), '-mybesetting')]"
          id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), concat('/backendHttpSettingsCollection/', parameters('applicationGateways_azure_app_name'), '-mybesetting'))]"
          properties:
            port: 80
            protocol: Http
            cookieBasedAffinity: Disabled
            pickHostNameFromBackendAddress: true
            requestTimeout: 20
            probe:
              id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), '/probes/http-probe')]"
      httpListeners:
        - name: "[concat(parameters('applicationGateways_azure_app_name'), '-mylistener')]"
          id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), concat('/httpListeners/', parameters('applicationGateways_azure_app_name'), '-mylistener'))]"
          properties:
            frontendIPConfiguration:
              id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), '/frontendIPConfigurations/appGwPublicFrontendIpIPv4')]"
            frontendPort:
              id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), '/frontendPorts/port_80')]"
            protocol: Http
            hostNames: []
            requireServerNameIndication: false
      urlPathMaps:
        - name: "[concat(parameters('applicationGateways_azure_app_name'), '-myrule')]"
          id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), concat('/urlPathMaps/', parameters('applicationGateways_azure_app_name'), '-myrule'))]"
          properties:
            defaultBackendAddressPool:
              id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), concat('/backendAddressPools/', parameters('applicationGateways_azure_app_name'), '-mybe'))]"
            defaultBackendHttpSettings:
              id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), concat('/backendHttpSettingsCollection/', parameters('applicationGateways_azure_app_name'), '-mybesetting'))]"
            pathRules:
              - name: "[concat(parameters('applicationGateways_azure_app_name'), '-mytarget')]"
                id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), concat('/urlPathMaps/', parameters('applicationGateways_azure_app_name'), '-myrule/pathRules/', parameters('applicationGateways_azure_app_name'), '-mytarget'))]"
                properties:
                  paths:
                    - /*
                  backendAddressPool:
                    id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), concat('/backendAddressPools/', parameters('applicationGateways_azure_app_name'), '-mybe'))]"
                  backendHttpSettings:
                    id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), concat('/backendHttpSettingsCollection/', parameters('applicationGateways_azure_app_name'), '-mybesetting'))]"
      requestRoutingRules:
        - name: "[concat(parameters('applicationGateways_azure_app_name'), '-myrule')]"
          id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), concat('/requestRoutingRules/', parameters('applicationGateways_azure_app_name'), '-myrule'))]"
          properties:
            ruleType: PathBasedRouting
            priority: 1
            httpListener:
              id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), concat('/httpListeners/', parameters('applicationGateways_azure_app_name'), '-mylistener'))]"
            urlPathMap:
              id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), concat('/urlPathMaps/', parameters('applicationGateways_azure_app_name'), '-myrule'))]"
      probes:
        - name: http-probe
          id: "[concat(resourceId('Microsoft.Network/applicationGateways', parameters('applicationGateways_azure_app_name')), '/probes/http-probe')]"
          properties:
            protocol: Http
            path: /
            interval: 30
            timeout: 30
            unhealthyThreshold: 3
            pickHostNameFromBackendHttpSettings: true
            match:
              statusCodes:
                - 200-399
      enableHttp2: true
      autoscaleConfiguration:
        minCapacity: 0
        maxCapacity: 10
outputs:
  applicationGatewayIp:
    type: string
    value: "[reference(resourceId('Microsoft.Network/publicIPAddresses', 'PLACEHOLDER_FOR_PUBLIC_IP_NAME')).ipAddress]"

```

## **10. Suffix Changes Deployment for `/app` Path**

This section addresses how to configure your Azure Web App and Application Gateway to serve your application under the `/app` path, ensuring correct routing and behavior for users accessing `http://<your-app-gateway-ip>/app`.

---

### **10.1 Modifying the Express Server**

To serve the React app under the `/app` path, update the Express server to serve static files under that path and configure a catch-all route for `/app`.

#### **Express Server Configuration**:

```javascript
const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 5000;

// Serve static files from the React app under /app
app.use('/app', express.static(path.join(__dirname, 'build')));

// Handle any requests to /app/*
app.get('/app/*', (req, res) => {
  res.sendFile(path.join(__dirname, 'build', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
```

---

### **10.2 Adjusting the React App**

You must configure React to be aware that it's being served under the `/app` path by updating the `homepage` in `package.json` and modifying React Router (if applicable).

#### **Set Homepage in `package.json`**:

Update your `package.json` file to specify the `/app` path as the `homepage`:

```json
{
  "name": "my-react-app",
  "version": "1.0.0",
  "private": true,
  "homepage": "/app",
  // ...other settings
}
```

#### **Adjust React Router** (If applicable):

If your React app uses **React Router**, update the `Router` to set the `basename` to `/app`.

```javascript
import { BrowserRouter as Router } from 'react-router-dom';

function App() {
  return (
    <Router basename="/app">
      {/* Your routes here */}
    </Router>
  );
}

export default App;
```

---

### **10.3 Configuring Azure Web App for `/app` Path**

Azure Web App does not require special configurations to serve your React + Express app under `/app`, but ensure your deployment settings (like environment variables) are correct.

1. **Deploy the Docker container** as usual.
2. Ensure that **your app serves requests to `/app`** correctly by testing the route after deployment.

### **10.4 Configuring Application Gateway for `/app` Path**

To ensure the Application Gateway correctly routes traffic to `/app`, you’ll configure **path-based routing** rules.

#### **1. Reuse Existing Backend Pool**:
Since both the root path (`/`) and `/app` use the same backend (Azure Web App) and port, you can reuse the same backend pool.

#### **2. Create a Path-Based Routing Rule for `/app`**:

1. **Navigate to Application Gateway** > **Rules**.
2. **Edit or Add a Path-Based Routing Rule**.
   - **Path `/`** → Routes to the root application.
   - **Path `/app/*`** → Routes to the same backend pool (since you're using the same App Service).

#### **Example Routing Rule**:
- **Path `/`** → Routes to **Backend Pool 1** (root service).
- **Path `/app`** → Routes to the same backend pool.

Ensure that traffic directed to `/app` correctly routes to the React app served under that path.

---

### **10.5 Dockerfile Adjustments for `/app` Path**

No changes are needed to the Dockerfile when deploying the React + Express app to `/app` because the routing logic is handled within the **Express server** and **React configuration**.

**Example Dockerfile** (for reference):

```Dockerfile
# Step 1: Build the React app
FROM node:16 AS build
WORKDIR /app/client
COPY client/package.json ./
RUN npm install
COPY client ./
RUN npm run build

# Step 2: Set up the Express server
FROM node:16
WORKDIR /app/server
COPY server

/package.json ./
RUN npm install
COPY server ./

# Copy the React build to the Express server
COPY --from=build /app/client/build /app/server/build

# Expose the server port
EXPOSE 5000

# Start the Express server
CMD ["node", "server.js"]
```

---

## **Conclusion**

This README outlines the detailed process of configuring and deploying a Dockerized React and Express application to Azure Web App and setting up Azure Application Gateway with path-based routing under `/app`. The suffix path adjustments ensure that users accessing `http://<app-gateway-ip>/app` are correctly served the React application. By following the steps outlined, you can deploy, manage, and scale your application efficiently.

