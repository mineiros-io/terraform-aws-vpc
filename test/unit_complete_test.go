package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestUnitComplete(t *testing.T) {
	t.Parallel()

	// deploy initial example with one nat gateway per az
	terraformOptions := &terraform.Options{
		TerraformDir: "unit-complete",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"nat_gateway_mode": "one_per_az",
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndPlan(t, terraformOptions)
	terraform.ApplyAndIdempotent(t, terraformOptions)

	// deploy upgraded example with single nat gateway
	terraformOptions = &terraform.Options{
		TerraformDir: "unit-complete",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"nat_gateway_mode": "single",
		},
	}
	terraform.Plan(t, terraformOptions)
	terraform.ApplyAndIdempotent(t, terraformOptions)

	// deploy upgraded example with no nat gateways
	terraformOptions = &terraform.Options{
		TerraformDir: "unit-complete",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"nat_gateway_mode": "none",
		},
	}
	terraform.Plan(t, terraformOptions)
	terraform.ApplyAndIdempotent(t, terraformOptions)
}
