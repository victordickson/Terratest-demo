

#To Deploy S3 bucket and EC2 instance, run

1.  terraform plan/apply will require aws credentials to run. It is recommended to provide these credentials as environment variables like this:

 export AWS_ACCESS_KEY_ID="anaccesskey"

export AWS_SECRET_ACCESS_KEY="asecretkey"

2. Initialize Terraform:

terraform init

3. Run terraform plan to check if there is something missing:

terraform plan

4. Then, Apply terraform:

terraform apply

5. To destroy, run:

terraform destroy

#To run Terratest

1. change to test directory:

cd test 

2. Initializa terratest:

go mod init "test"

go mod tidy

3. Run the test:
=======
_To Deploy S3 bucket and EC2 instance_, run

terraform init

terraform plan

terraform apply

_To destroy_, run

terraform destroy

_To run Terratest_

cd test

go mod init test

go test -v
