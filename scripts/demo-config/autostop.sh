#!/bin/bash
sudo -u ec2-user -i <<'EOF'

pip install pandas
pip install boto3==1.26.90
pip install s3fs==2022.1.0
python -m pip install -U sentence-transformers
pip install papermill

echo "Current directory: ${PWD}"
cd /home/ec2-user/SageMaker/
echo "Changing directory to: ${PWD}"
nohup python3 execution_file.py & 
EOF