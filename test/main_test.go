package test

import (
	"fmt"
	"testing"

	//"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformTerraformTest(t *testing.T) {
	t.Parallel()

	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	// Specify A Region And Names For Resourses For Provisioning
	approvedRegions := []string{"us-west-1"}
	awsRegion := aws.GetRandomRegion(t, approvedRegions, nil)
	expectedNameEC2 := fmt.Sprintf("Flugel-%s", random.UniqueId())
	expectedNameS3 := fmt.Sprintf("Flugel-%s", random.UniqueId())
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Variables Will Be Passed To Terraform Code
		Vars: map[string]interface{}{
			"instance_name": expectedNameEC2,
			"s3_name":       expectedNameS3,
			"owner":         "InfraTeam",
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created.
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)
	actualInstanceId := []string{}
	actualBucketId := ""

	// Check Resources By Lookingup Tags And Associated IDs
	tagName := "Name"

	exptectedInstanceId := aws.GetEc2InstanceIdsByTag(t, awsRegion, tagName, expectedNameEC2)
	expectedBucketID := aws.FindS3BucketWithTag(t, awsRegion, tagName, expectedNameS3)

	// Compare And Validate If It Match
	assert.Equal(t, exptectedInstanceId, actualInstanceId)
	assert.Equal(t, expectedBucketID, actualBucketId)

}
