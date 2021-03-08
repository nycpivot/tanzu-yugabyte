read -p "AWS Config (aws-ap-south-one): " aws_config_name
read -p "Worker Count: " worker_machine_count

sudo tkg create cluster tanzu-yugabyte-${aws_config_name} --plan dev --worker-machine-count ${worker_machine_count} --config .tkg/${aws_config_name}.yaml
sudo tkg get credentials tanzu-yugabyte-${aws_config_name} --config .tkg/${aws_config_name}.yaml

sudo kubectl config use-context tanzu-yugabyte-${aws_config_name}-admin@tanzu-yugabyte-${aws_config_name}
