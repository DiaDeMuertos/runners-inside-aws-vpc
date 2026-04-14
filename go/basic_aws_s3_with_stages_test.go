package test

import (
	"fmt"
	"math/rand"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestAwsS3WithStages(t *testing.T) {
	t.Parallel()

	var bucketName string = fmt.Sprintf("terraform-up-and-running-state-%d", time.Now().Unix())

	rand.Seed(time.Now().UnixNano())

	// Define working directory
	workingDir := "../terraform/test/basic-aws-s3/"

	// Stage 1: Setup
	test_structure.RunTestStage(t, "setup", func() {
		t.Log("Running setup stage")

		terraformOptions := &terraform.Options{
			TerraformDir: workingDir,
			Vars: map[string]interface{}{
				"name": fmt.Sprintf("%s", bucketName),
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

		fooOutput := terraform.Output(t, terraformOptions, "foo")
		t.Logf("[VALIDATE] LOG: foo=%s", fooOutput)

		bucketNameOutputRaw := terraform.Output(t, terraformOptions, "name")
		t.Logf("[VALIDATE] LOG: name:%s", bucketNameOutputRaw)

		// if bucketNameOutput == "" {
		// 	t.Error("Bucket name output is empty!")
		// }

		// if bucketNameOutput != bucketName {
		// 	t.Errorf("Expected bucket name to be %s, but got %s", bucketNameOutput, bucketName)
		// }
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

func TestIsWorking(t *testing.T) {
	t.Parallel()

	fmt.Println()
	fmt.Println("If you see this text, it's working!")
	fmt.Println()
}
