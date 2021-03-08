read -p "AWS Config (aws-ap-south-one): " aws_config_name
read -p "Worker Count: " worker_machine_count

sudo tkg create cluster --name tanzu-yugabyte-${aws_config_name} --plan dev --worker-machine-count ${worker-machine-count} --config .tkg/${aws_config_name}.yaml
sudo tkg get credentials tanzu-yugabyte-${aws_config_name} --config .tkg/${aws_config_name}

sudo kubectl config use-context tanzu-yugabyte-${aws_config_name}-admin@tanzu-yugabyte-${aws_config_name}
