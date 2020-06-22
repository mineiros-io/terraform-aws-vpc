package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestVPC(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/complete-example",
		Upgrade:      true,
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)
}
