#!/bin/bash

echo "========================================="
echo "Cleaning Kubernetes Probe Resources"
echo "========================================="

kubectl delete -f manifests/exec-liveness.yaml
kubectl delete -f manifests/http-liveness.yaml
kubectl delete -f manifests/tcp-liveness-readiness.yaml
kubectl delete -f manifests/startup-probe.yaml
kubectl delete -f manifests/readiness-probe.yaml
kubectl delete -f manifests/grpc-liveness.yaml

echo ""
echo "========================================="
echo "Cleanup Completed"
echo "========================================="
