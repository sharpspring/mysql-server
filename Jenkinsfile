library 'jenkins-utils'
node('k8s') {
    stage("Checkout") {
        checkout scm
    }

    stage("Build image") {
        sh("docker pull us.gcr.io/sharpspring-us/mysql:unleaded")
        sh("docker build . -t us.gcr.io/sharpspring-us/mysql:unleaded --cache-from us.gcr.io/sharpspring-us/mysql:unleaded")
    }

    stage('Push image to registry') {
        sh("docker push us.gcr.io/sharpspring-us/mysql:unleaded")
    }
}
