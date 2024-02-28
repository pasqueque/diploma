apiVersion: apps/v1
kind: Deployment
metadata:
  name: diploma-test-app
  labels:
    app.kubernetes.io/name: diploma-test-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app.kubernetes.io/name: diploma-test-app
  template:
    metadata:
      labels:
        app.kubernetes.io/name: diploma-test-app
    spec:
      containers:
      - name: diploma-test-app
        image: pasqueque/pasqueque-repo:jenkins-test_new_app-41
        ports:
        - containerPort: 80