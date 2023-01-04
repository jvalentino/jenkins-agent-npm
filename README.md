# Jenkins Agent NPM

This project is a docker-based build agent with the capability of running NPM via NVM.

More importantly, the process for building **and testing** this agent is fully automated.

Prerequisites

- For building on Jenkins: https://github.com/jvalentino/jenkins-agent-docker
- For running Jenkins use Docker Agents: https://github.com/jvalentino/example-jenkins-docker-jcasc-2

# Locally

## Build

I wrote a script to run the underlying command:

```bash
$ ./build.sh 
+ docker build -t jvalentino2/jenkins-agent-npm .
[+] Building 0.9s (11/11) FINISHED                                                                           
 => [internal] load build definition from Dockerfile                                                    0.0s
 => => transferring dockerfile: 722B                                                                    0.0s
 => [internal] load .dockerignore                                                                       0.0s
 => => transferring context: 2B                                                                         0.0s
 => [internal] load metadata for docker.io/jenkins/agent:latest-jdk11                                   0.8s
 => [auth] jenkins/agent:pull token for registry-1.docker.io                                            0.0s
 => [1/6] FROM docker.io/jenkins/agent:latest-jdk11@sha256:cbafd026949fd9a796eb3d125a4eaa83aa876ac13ba  0.0s
 => CACHED [2/6] RUN rm /bin/sh && ln -s /bin/bash /bin/sh                                              0.0s
 => CACHED [3/6] RUN apt-get update &&      apt-get install -y gcc &&     apt-get install -y curl       0.0s
 => CACHED [4/6] WORKDIR /opt/nvm                                                                       0.0s
 => CACHED [5/6] RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash     0.0s
 => CACHED [6/6] WORKDIR /home/jenkins                                                                  0.0s
 => exporting to image                                                                                  0.0s
 => => exporting layers                                                                                 0.0s
 => => writing image sha256:7ce1a463f86634b0fc7a8126e9e6d44fbae8282066b69783265a727768f5af30            0.0s
 => => naming to docker.io/jvalentino2/jenkins-agent-npm                                                0.0s
```

The result is the image of `jvalentino2/jenkins-agent-npm`.

## Run

If you want to open a temporary shell into an instance of this image, run the following command:

```bash
$ ./run.sh 
+ docker compose run --rm jenkins_agent_npm
root@c2c5fc4708b1:/home/jenkins# 
```

This opens a shell into container, where you can do things like verify the versions in use:

```bash
root@c2c5fc4708b1:/home/jenkins# nvm -v
0.39.3
root@c2c5fc4708b1:/home/jenkins# node -v
v19.2.0
root@c2c5fc4708b1:/home/jenkins# npm -v
8.19.3
```

when done, just type:

```bash
root@5e02d6963730:/home/jenkins# exit
exit
~/workspaces/personal/jenkins-agent-maven $ 
```

It will kill the container and put you back at your own shell.



## Test

It is important to know that this container can actually build an NPM project, so a script was included to launch the container and also run an NPM build on the project within the workspace. It will then check for the specific files and return a non-zero exit code if they are not found.

```bash
$ ./test.sh
+ docker compose run --rm jenkins_agent_npm sh -c 'cd workspace; ./test.sh'
+ cd example-js-npm-lib-3
+ rm -rf node_modules
+ npm install

added 461 packages, and audited 462 packages in 47s

64 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
npm notice 
npm notice New major version of npm available! 8.19.3 -> 9.2.0
npm notice Changelog: https://github.com/npm/cli/releases/tag/v9.2.0
npm notice Run npm install -g npm@9.2.0 to update!
npm notice 
+ npm run format

> example-js-npm-lib-3@1.0.0 format
> npx prettier-eslint "src/**/*.js" --write -l info

1 file was unchanged
+ npm run check

> example-js-npm-lib-3@1.0.0 check
> npx eslint --fix src --format html -o build/eslint.html

+ npm run test

> example-js-npm-lib-3@1.0.0 test
> npx c8 mocha --reporter spec test --recursive



  index.js
    ✔ test hello


  1 passing (7ms)

----------|---------|----------|---------|---------|-------------------
File      | % Stmts | % Branch | % Funcs | % Lines | Uncovered Line #s 
----------|---------|----------|---------|---------|-------------------
All files |   81.25 |      100 |      50 |   81.25 |                   
 index.js |   81.25 |      100 |      50 |   81.25 | 9-11              
----------|---------|----------|---------|---------|-------------------
+ npm run verify

> example-js-npm-lib-3@1.0.0 verify
> npx c8 check-coverage --lines 80

+ npm run build

> example-js-npm-lib-3@1.0.0 build
> rollup -c


src/index.js → dist/example-js-npm-lib-3.umd.js...
babelHelpers: 'bundled' option was used by default. It is recommended to configure this option explicitly, read more here: https://github.com/rollup/plugins/tree/master/packages/babel#babelhelpers
(!) Missing global variable name
Use output.globals to specify browser global variable names corresponding to external modules
fs (guessing 'require$$0')
created dist/example-js-npm-lib-3.umd.js in 4.2s

src/index.js → dist/example-js-npm-lib-3.cjs.js, dist/example-js-npm-lib-3.esm.js...
babelHelpers: 'bundled' option was used by default. It is recommended to configure this option explicitly, read more here: https://github.com/rollup/plugins/tree/master/packages/babel#babelhelpers
created dist/example-js-npm-lib-3.cjs.js, dist/example-js-npm-lib-3.esm.js in 59ms
+ echo ' '
 
+ echo Validation...
Validation...
+ '[' '!' -f build/eslint.html ']'
+ '[' '!' -f coverage/index.html ']'
+ '[' '!' -f dist/example-js-npm-lib-3.cjs.js ']'
+ '[' '!' -f dist/example-js-npm-lib-3.esm.js ']'
+ '[' '!' -f dist/example-js-npm-lib-3.umd.js ']'
+ echo 'Validation Done'
Validation Done
~/workspaces/personal/jenkins-agent-npm $ 
```

This works by included the project of https://github.com/jvalentino/example-js-npm-lib-3 in the workspace directory, where the workspace directory is mounted to the container volume via docker compose.

# On Jenkins

On Jenkins, the pipeline itself requires the image build from https://github.com/jvalentino/jenkins-agent-docker, which is jvalentino2/jenkins-agent-docker. The docker label on Jenkins must be mapped to that jvalentino2/jenkins-agent-docker image.

![](https://github.com/jvalentino/jenkins-agent-docker/raw/main/wiki/02.png)

In this case though, the actual image in use in jvalentino2/jenkins-agent-docker:latest to always pull the latest.

The Jenkinsfile itself then calls the same commands as the Docker Agent, to build, test, and then publish that image to Dockerhub:

```groovy
pipeline {
 agent { label 'docker' }

 environment {
    IMAGE_NAME    = 'jvalentino2/jenkins-agent-npm'
    MAJOR_VERSION = '1'
    HUB_CRED_ID   = 'dockerhub'
  }

  stages {
    
    stage('Docker Start') {
      steps {
       dockerStart()
      }
    } // Docker Start

     stage('Build') {
      steps {
       build("${env.IMAGE_NAME}")
      }
    } // Build

    stage('Test') {
      steps {
       test()
      }
    } // Test
    
    stage('Publish') {
      steps {
        publish("${env.IMAGE_NAME}", "${env.MAJOR_VERSION}", "${env.HUB_CRED_ID}")
      }
    } // Publish

    stage('Docker Stop') {
      steps {
       dockerStop()
      }
    } // Docker Start

  }
}

def dockerStart() {
  sh '''
    nohup dockerd &
    sleep 10
  '''
}

def dockerStop() {
  sh 'cat /var/run/docker.pid | xargs kill -9 || true'
}

def build(imageName) {
  sh "docker build -t ${imageName} ."
}

def test() {
  sh "./test.sh"
}

def publish(imageName, majorVersion, credId) {
  withCredentials([usernamePassword(
      credentialsId: credId, 
      passwordVariable: 'DOCKER_PASSWORD', 
      usernameVariable: 'DOCKER_USERNAME')]) {
          sh """
              docker login --username $DOCKER_USERNAME --password $DOCKER_PASSWORD
              docker tag ${imageName}:latest ${imageName}:${majorVersion}.${BUILD_NUMBER}
              docker tag ${imageName}:latest ${imageName}:latest
              docker push ${imageName}:${majorVersion}.${BUILD_NUMBER}
              docker push ${imageName}:latest
          """
      }
}
```

Note that I wrote groovy methods to handle running the underlying commands via different stages.