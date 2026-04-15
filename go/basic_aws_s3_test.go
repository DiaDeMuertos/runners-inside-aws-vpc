package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAwsS3(t *testing.T) {
	var bucketName string = fmt.Sprintf("terraform-up-and-running-state-%d", time.Now().Unix())

	opts := &terraform.Options{
		TerraformDir: "../terraform/test/basic-aws-s3/",

		Vars: map[string]interface{}{
			"name": fmt.Sprintf("%s", bucketName),
		},
	}
	terraform.Init(t, opts)
	terraform.Apply(t, opts)

	out := terraform.OutputAll(t, opts)
	t.Logf("All outputs: %#v", out)

	// strings.TrimSpace(terraform.OutputRequired(t, opts, "name"))

	// assert.Equal(t, bucketName, outputName)

	defer terraform.Destroy(t, opts)
}
