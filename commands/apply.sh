#!/bin/bash

echo "========================================="
echo "Kubernetes Probes Lab Setup Started"
echo "========================================="

echo ""
echo "Applying Exec Liveness Probe..."
kubectl apply -f manifests/exec-liveness.yaml

echo ""
echo "Applying HTTP Liveness Probe..."
kubectl apply -f manifests/http-liveness.yaml

echo ""
echo "Applying TCP Liveness & Readiness Probe..."
kubectl apply -f manifests/tcp-liveness-readiness.yaml

echo ""
echo "Applying Startup Probe..."
kubectl apply -f manifests/startup-probe.yaml

echo ""
echo "Applying Readiness Probe..."
kubectl apply -f manifests/readiness-probe.yaml

echo ""
echo "Applying gRPC Liveness Probe..."
kubectl apply -f manifests/grpc-liveness.yaml

echo ""
echo "========================================="
echo "All Probe Examples Applied Successfully"
echo "========================================="
