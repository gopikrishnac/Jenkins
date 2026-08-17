# Jenkins Server Setup & Pipeline Prerequisites

Before running the Jenkins pipeline, make sure the Jenkins server has all the required dependencies and permissions configured.

## Prerequisites

The Jenkins server must have the following installed and configured:

* Docker
* Python 3
* pip
* pytest
* Jenkins user access to the Docker daemon
* Project files available in the `04-docker` directory

---

## 1. Connect to the Jenkins Server

SSH into the Jenkins server:

```bash
ssh -i <your-key.pem> ec2-user@<JENKINS-SERVER-IP>
```

Verify that you are connected to the correct server:

```bash
hostname
whoami
```

---

## 2. Install Docker

Install Docker on the Jenkins server.

For Amazon Linux:

```bash
sudo dnf install -y docker
```

Start the Docker service:

```bash
sudo systemctl start docker
```

Enable Docker to start automatically after a reboot:

```bash
sudo systemctl enable docker
```

Verify that Docker is running:

```bash
sudo systemctl status docker
```

Verify the Docker installation:

```bash
docker --version
```

---

## 3. Give Jenkins Permission to Use Docker

The Jenkins pipeline needs access to the Docker daemon.

Add the Jenkins user to the `docker` group:

```bash
sudo usermod -aG docker jenkins
```

Verify the group membership:

```bash
id jenkins
```

The output should contain:

```text
docker
```

Restart Jenkins so that the new group membership takes effect:

```bash
sudo systemctl restart jenkins
```

Verify Docker access as the Jenkins user:

```bash
sudo -u jenkins -H bash -c 'docker ps'
```

If Docker is configured correctly, the command should execute without a permission-denied error.

> **Note:** Do not use `chmod 666 /var/run/docker.sock` to solve Docker permission issues. Adding the Jenkins user to the Docker group is the preferred configuration.

---

## 4. Install Python 3

Check whether Python is already installed:

```bash
python3 --version
```

If Python is not installed:

```bash
sudo dnf install -y python3
```

Verify:

```bash
python3 --version
```

---

## 5. Install pip

Check whether pip is installed:

```bash
pip3 --version
```

If pip is not installed:

```bash
sudo dnf install -y python3-pip
```

Verify:

```bash
pip3 --version
```

---

## 6. Install pytest

Install pytest using pip:

```bash
pip3 install pytest
```

Verify the installation:

```bash
pytest --version
```

The command should return the installed pytest version.

### Recommended: Use a Virtual Environment

For a cleaner Python setup, create a virtual environment inside the project:

```bash
python3 -m venv .venv
```

Activate it:

```bash
source .venv/bin/activate
```

Upgrade pip:

```bash
pip install --upgrade pip
```

Install pytest:

```bash
pip install pytest
```

Verify:

```bash
pytest --version
```

---

## 7. Use the Correct Project Directory

The Jenkins pipeline commands must be executed from the following project directory:

```text
04-docker
```

Navigate to the directory:

```bash
cd 04-docker
```

Verify the current directory:

```bash
pwd
```

Verify the project files:

```bash
ls -la
```

The pipeline should use `04-docker` as the working directory when executing Docker and pytest commands.

---

## 8. Verify the Complete Environment

Before running the Jenkins pipeline, verify all required dependencies:

```bash
docker --version
```

```bash
python3 --version
```

```bash
pip3 --version
```

```bash
pytest --version
```

Then verify Docker access:

```bash
docker ps
```

Finally, make sure you are working from the correct project directory:

```bash
cd 04-docker
pwd
```

The expected path should end with:

```text
04-docker
```

---

## 9. Jenkins Pipeline Requirements

The Jenkins pipeline should execute its commands from the `04-docker` directory.

For example:

```groovy
stage('Run Tests') {
    steps {
        dir('04-docker') {
            sh '''
                pytest
            '''
        }
    }
}
```

For Docker commands:

```groovy
stage('Build Docker Image') {
    steps {
        dir('04-docker') {
            sh '''
                docker build -t <dockerhub-username>/<image-name>:latest .
            '''
        }
    }
}
```

This ensures that Docker receives the correct `Dockerfile` and application files from the `04-docker` directory.

---

## 10. Pre-Pipeline Checklist

Before starting the Jenkins pipeline, verify:

* [ ] Docker is installed on the Jenkins server
* [ ] Docker service is running
* [ ] Jenkins user belongs to the `docker` group
* [ ] Jenkins has permission to execute Docker commands
* [ ] Python 3 is installed
* [ ] pip is installed
* [ ] pytest is installed
* [ ] Jenkins checks out the project successfully
* [ ] Pipeline commands execute from the `04-docker` directory
* [ ] Docker Hub credentials are configured in Jenkins
* [ ] Docker Hub authentication uses a Personal Access Token (PAT), not a plain-text password

Once all of these requirements are satisfied, the Jenkins pipeline should have the environment required to build, test, authenticate with Docker Hub, and push the Docker image successfully.
