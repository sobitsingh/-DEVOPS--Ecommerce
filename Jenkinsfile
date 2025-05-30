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
                        kubectl apply -f virtual-service.yaml
                        kubectl delete po --all -n default
                    '''
                }
            }
            }
        }
        stage("ELK Setup"){
            steps{
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws']]){
                    script{
                        sh """
                        cd ultimate-devops-project-demo/kubernetes/ELK/
                        helm repo add elastic https://helm.elastic.co
                        helm repo update
                        helm install elasticsearch elastic/elasticsearch -f elasticsearch-values.yaml
                        helm install filebeat elastic/filebeat -f filebeat-values.yaml
                        helm install logstash elastic/logstash -f logstash-values.yaml
                        helm install kibana elastic/kibana -f kibana-values.yaml
                        kubectl get secret elasticsearch-master-credentials -o jsonpath="{.data.username}" | base64 --decode
                        kubectl get svc kibana-kibana

                        """
                    }
                }
            }
        }
    }
}