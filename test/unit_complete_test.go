package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
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
	terraform.Apply(t, terraformOptions)

	stdout := terraform.Plan(t, terraformOptions)

	resourceCount := terraform.GetResourceCount(t, stdout)
	assert.Equal(t, 0, resourceCount.Add, "No resources should have been created. Found %d instead.", resourceCount.Add)
	assert.Equal(t, 0, resourceCount.Change, "No resources should have been changed. Found %d instead.", resourceCount.Change)
	assert.Equal(t, 0, resourceCount.Destroy, "No resources should have been destroyed. Found %d instead.", resourceCount.Destroy)

	// deploy upgraded example with single nat gateway
	terraformOptions = &terraform.Options{
		TerraformDir: "unit-complete",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"nat_gateway_mode": "single",
		},
	}
	terraform.Plan(t, terraformOptions)
	terraform.Apply(t, terraformOptions)

	stdout = terraform.Plan(t, terraformOptions)

	resourceCount = terraform.GetResourceCount(t, stdout)
	assert.Equal(t, 0, resourceCount.Add, "No resources should have been created. Found %d instead.", resourceCount.Add)
	assert.Equal(t, 0, resourceCount.Change, "No resources should have been changed. Found %d instead.", resourceCount.Change)
	assert.Equal(t, 0, resourceCount.Destroy, "No resources should have been destroyed. Found %d instead.", resourceCount.Destroy)

	// deploy upgraded example with no nat gateways
	terraformOptions = &terraform.Options{
		TerraformDir: "unit-complete",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"nat_gateway_mode": "none",
		},
	}
	terraform.Plan(t, terraformOptions)
	terraform.Apply(t, terraformOptions)

	stdout = terraform.Plan(t, terraformOptions)

	resourceCount = terraform.GetResourceCount(t, stdout)
	assert.Equal(t, 0, resourceCount.Add, "No resources should have been created. Found %d instead.", resourceCount.Add)
	assert.Equal(t, 0, resourceCount.Change, "No resources should have been changed. Found %d instead.", resourceCount.Change)
	assert.Equal(t, 0, resourceCount.Destroy, "No resources should have been destroyed. Found %d instead.", resourceCount.Destroy)
}
