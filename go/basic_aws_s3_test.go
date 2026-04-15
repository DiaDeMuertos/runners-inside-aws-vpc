package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
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

	outputName := strings.TrimSpace(terraform.OutputRequired(t, opts, "name"))

	assert.Equal(t, bucketName, outputName)

	defer terraform.Destroy(t, opts)
}
