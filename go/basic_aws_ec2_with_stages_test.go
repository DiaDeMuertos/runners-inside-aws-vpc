package test

import (
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestAwsEC2WithStages(t *testing.T) {
	t.Parallel()

	// var instanceName string = ""

	// Define working directory
	workingDir := "../terraform/test/basic-aws-ec2/"

	// Stage 1: Setup
	test_structure.RunTestStage(t, "setup", func() {
		t.Log("Running setup stage")

		terraformOptions := &terraform.Options{
			TerraformDir: workingDir,
			Vars:         map[string]interface{}{
				// "name": fmt.Sprintf("%s", instanceName),
			},
		}
		// Save options for later stages
		test_structure.SaveTerraformOptions(t, workingDir, terraformOptions)

		// Init & Apply
		terraform.InitAndApply(t, terraformOptions)
	})

	// Stage 2: Validate
	test_structure.RunTestStage(t, "validate", func() {
		t.Log("<-- Running validate stage -->")
		terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)

		// Example: check output
		publicIP := terraform.Output(t, terraformOptions, "public_ip")
		privateIP := terraform.Output(t, terraformOptions, "private_ip")

		time.Sleep(2 * time.Minute)

		url := "http://" + Ternary(publicIP != "", publicIP, privateIP)
		t.Logf("[VALIDATE] LOG: url=%s", url)

		// Retry until the instance responds with 200 OK
		expectedStatus := 200
		expectedBody := "<h1>Hello, World!</h1>"
		maxRetries := 3
		timeBetweenRetries := 2 * time.Second

		http_helper.HttpGetWithRetry(t, url, nil, expectedStatus, expectedBody, maxRetries, timeBetweenRetries)
	})

	// Stage 3: Teardown
	test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)
		terraform.Destroy(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "mock", func() {
		t.Log("<-- Running mock stage -->")
	})
}

func Ternary[T any](condition bool, a, b T) T {
	if condition {
		return a
	}
	return b
}
