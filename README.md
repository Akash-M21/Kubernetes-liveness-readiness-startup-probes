# Kubernetes Probes Examples

A hands-on Kubernetes project demonstrating how health checks work using:

- Liveness Probes
- Readiness Probes
- Startup Probes
- HTTP Probes
- TCP Probes
- Exec Probes
- gRPC Probes

This project helps understand how Kubernetes monitors container health and manages traffic routing and container restarts.

The examples are based on Kubernetes official documentation:
https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/

---

# 📚 Topics Covered

| Probe Type | Purpose |
|---|---|
| Liveness Probe | Detect unhealthy containers and restart them |
| Readiness Probe | Control when Pods receive traffic |
| Startup Probe | Protect slow-starting applications |
| HTTP Probe | Check HTTP endpoints |
| TCP Probe | Verify TCP socket availability |
| Exec Probe | Run commands inside containers |
| gRPC Probe | Perform gRPC health checks |

---

# 🏗 Project Structure

```text
Kubernetes-Probes-Examples/
│
├── README.md
│
├── manifests/
│   ├── exec-liveness.yaml
│   ├── http-liveness.yaml
│   ├── tcp-liveness-readiness.yaml
│   ├── startup-probe.yaml
│   ├── readiness-probe.yaml
│   └── grpc-liveness.yaml
│
└── commands/
    ├── apply.sh
    └── cleanup.sh
```

---

# 🚀 Pre-requisites

Before starting, ensure you have:

- Kubernetes Cluster
- kubectl installed
- Minimum 2 nodes recommended
- Basic understanding of Pods and Deployments

Verify cluster:

```bash
kubectl get nodes
```

---

# 🧠 Understanding Kubernetes Probes

Kubernetes uses probes to monitor container health.

The kubelet continuously checks containers using probes and takes actions based on probe results.

Probes help Kubernetes:
- restart unhealthy containers
- stop traffic to unhealthy Pods
- protect slow-starting applications

Without probes:
- broken applications may continue running
- traffic may be sent to unhealthy Pods
- users may experience failures

---

# 🔥 Probe Types

| Probe | Purpose |
|---|---|
| Liveness | Is the container alive? |
| Readiness | Can the container receive traffic? |
| Startup | Has the application finished starting? |

---

# 1️⃣ Exec Liveness Probe

## File

```text
manifests/exec-liveness.yaml
```

## Purpose

Exec probes run commands inside containers.

Kubernetes checks container health by executing a command.

In this example:

```yaml
exec:
  command:
  - cat
  - /tmp/healthy
```

If the command succeeds:
- container is healthy

If the command fails:
- Kubernetes restarts the container

---

## Apply

```bash
kubectl apply -f manifests/exec-liveness.yaml
```

---

## Verify

```bash
kubectl describe pod liveness-exec
```

---

## What Happens

The container:
- creates `/tmp/healthy`
- waits 30 seconds
- deletes the file

After deletion:
- liveness probe fails
- kubelet restarts container

---

## ✅ Advantages

- Simple
- Works without HTTP server
- Useful for scripts or legacy apps

## ❌ Limitations

- Can increase container overhead
- Command execution may be expensive

## ✅ Use Cases

- Legacy applications
- Script-based containers
- Internal health checks

---

# 2️⃣ HTTP Liveness Probe

## File

```text
manifests/http-liveness.yaml
```

## Purpose

HTTP probes check application endpoints.

Kubernetes sends HTTP GET requests to verify health.

Example:

```yaml
httpGet:
  path: /healthz
  port: 8080
```

If response code is:
- 200–399 → healthy
- other status → unhealthy

---

## Apply

```bash
kubectl apply -f manifests/http-liveness.yaml
```

---

## ✅ Advantages

- Most common probe type
- Easy to implement
- Great for APIs and web apps

## ❌ Limitations

- Requires HTTP endpoint
- Bad probe design can cause restarts

## ✅ Use Cases

- REST APIs
- Web applications
- Microservices

---

# 3️⃣ TCP Liveness & Readiness Probe

## File

```text
manifests/tcp-liveness-readiness.yaml
```

## Purpose

TCP probes verify whether a TCP socket is open.

Kubernetes attempts to connect to a container port.

Example:

```yaml
tcpSocket:
  port: 8080
```

If connection succeeds:
- container is healthy

If connection fails:
- probe fails

---

## Apply

```bash
kubectl apply -f manifests/tcp-liveness-readiness.yaml
```

---

## Readiness vs Liveness

### Liveness Probe

Checks:
- should container restart?

### Readiness Probe

Checks:
- should Pod receive traffic?

If readiness fails:
- Pod remains running
- traffic stops

If liveness fails:
- container restarts

---

## ✅ Advantages

- Lightweight
- Simple
- No HTTP endpoint needed

## ❌ Limitations

- Only checks port availability
- Cannot verify application logic

## ✅ Use Cases

- Databases
- TCP services
- gRPC services without HTTP

---

# 4️⃣ Startup Probe

## File

```text
manifests/startup-probe.yaml
```

## Purpose

Startup probes protect slow-starting applications.

Without startup probes:
- liveness probes may restart apps before startup completes

Startup probes delay liveness and readiness checks until startup succeeds.

---

## Example

```yaml
startupProbe:
  httpGet:
    path: /healthz
    port: 8080
```

---

## Why Startup Probes Matter

Some applications:
- load large datasets
- initialize caches
- perform migrations
- take minutes to start

Startup probes prevent premature restarts.

---

## ✅ Advantages

- Prevents startup failures
- Protects slow applications
- Better reliability

## ❌ Limitations

- Incorrect timing can delay failure detection

## ✅ Use Cases

- Java applications
- Spring Boot apps
- Database initialization
- Large enterprise applications

---

# 5️⃣ Readiness Probe

## File

```text
manifests/readiness-probe.yaml
```

## Purpose

Readiness probes determine whether a Pod can receive traffic.

If readiness fails:
- Pod is removed from Service endpoints
- traffic stops temporarily

The container itself continues running.

---

## Important

Readiness probes:
- DO NOT restart containers
- only affect traffic routing

---

## Example

```yaml
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
```

---

## ✅ Advantages

- Prevents traffic to unhealthy Pods
- Improves application reliability
- Supports graceful deployments

## ❌ Limitations

- Incorrect configuration may block traffic

## ✅ Use Cases

- APIs
- Stateful applications
- Services with dependencies

---

# 6️⃣ gRPC Probe

## File

```text
manifests/grpc-liveness.yaml
```

## Purpose

gRPC probes check services implementing the gRPC Health Checking Protocol.

Example:

```yaml
grpc:
  port: 2379
```

---

## Important

gRPC probes:
- require Kubernetes v1.27+
- require gRPC health endpoint support

---

## Apply

```bash
kubectl apply -f manifests/grpc-liveness.yaml
```

---

## ✅ Advantages

- Native gRPC health checking
- Efficient
- Better for gRPC microservices

## ❌ Limitations

- Requires protocol support
- No named ports support

## ✅ Use Cases

- etcd
- gRPC applications
- Modern microservices

---

# 🔍 Important Probe Parameters

| Parameter | Description |
|---|---|
| initialDelaySeconds | Delay before first probe |
| periodSeconds | Probe frequency |
| timeoutSeconds | Probe timeout |
| successThreshold | Required successful checks |
| failureThreshold | Failed checks before action |

---

# 🔍 Verification Commands

## Check Pods

```bash
kubectl get pods
```

## Describe Pod

```bash
kubectl describe pod <pod-name>
```

## View Events

```bash
kubectl get events
```

## View Restart Count

```bash
kubectl get pods
```

---

# 🚨 Troubleshooting

## Container Restarting Repeatedly

Possible causes:
- aggressive liveness probe
- slow application startup
- incorrect health endpoint

---

## Pod Not Receiving Traffic

Possible causes:
- readiness probe failure
- dependency unavailable
- endpoint timeout

---

## Probe Timing Issues

Adjust:
- initialDelaySeconds
- timeoutSeconds
- failureThreshold

---

# 🧠 Real-World Best Practices

## Use Readiness Probes

Readiness probes are considered almost mandatory in production environments.

---

## Be Careful with Liveness Probes

Poorly configured liveness probes can cause restart loops and cascading failures under load.

---

## Use Startup Probes for Slow Apps

Startup probes help prevent slow applications from being restarted before initialization completes.

---

# 🎯 Learning Outcomes

After completing this project, you will understand:

- Kubernetes health checks
- Container restart behavior
- Traffic management
- Difference between readiness and liveness
- Startup probe protection
- HTTP/TCP/gRPC health checks
- Kubernetes troubleshooting

---

# 🔥 Future Improvements

You can extend this project with:

- Probe failure simulations
- CrashLoopBackOff examples
- Spring Boot Actuator probes
- NGINX health checks
- Helm integration
- Deployment rolling updates

---

# 📖 References

- Kubernetes Official Documentation
- Kubernetes Probes Documentation
- Official Kubernetes Task Guide
- Kubernetes Concepts Guide

---

# ⭐ Author

Akash M
