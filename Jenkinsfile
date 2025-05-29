pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        CLUSTER_NAME = 'open-tele-eks'
    }

    stages {
        stage('Configure Kubeconfig') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws']]) {
                    script {
                        sh '''
                            aws eks update-kubeconfig \
                                --region $AWS_REGION \
                                --name $CLUSTER_NAME
                        '''
                    }
                }
            }
        }

        stage('eks-deploy') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws']]){
                script {
                    echo "Deploying to EKS"
                    sh '''
                        cd ultimate-devops-project-demo/kubernetes/
                        istioctl install --set profile=demo -y
                        kubectl label namespace default istio-injection=enabled --overwrite
                        echo "[STEP 4] Verifying Kiali and Prometheus services"
                        kubectl get svc kiali -n istio-system || {
                            echo "[INFO] Kiali service not found. Applying manually..."
                            kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.22/samples/addons/kiali.yaml
                        }

                        kubectl get svc prometheus -n istio-system || {
                            echo "[INFO] Prometheus service not found. Applying manually..."
                            kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.22/samples/addons/prometheus.yaml
                        }
                        kubectl get svc grafana -n istio-system || {
                            echo "[INFO] Grafana service not found. Applying manually..."
                            kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.22/samples/addons/grafana.yaml
                        }
                        kubectl apply -f complete-deploy.yaml
                        kubectl delete po --all -n default
                    '''
                }
            }
            }
        }
    }
}