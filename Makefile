
# Disable CGO to avoid error "cgo: exec /missing-cc: fork/exec /missing-cc: no such file or directory"
# Ref. https://golang.org/cmd/cgo/
export CGO_ENABLED=0

help: ## Show this Makefile's help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

prepare: ## Prepare Terraform's environment by downloading and initializing its plugins and backends
	@terraform init

validate: prepare ## Run a static validation on the local files
	@terraform validate
	@tfsec --exclude-downloaded-modules
	## Enable test's code linting. Requires golangci-lint to be installed in the image
	# @golangci-lint run ./tests/

tests: ## Execute the test harness
	@go test -v -timeout 30m ./tests/

clean: ## Remove any temporary artefacts generated by this Makefile
	@rm -rf $(CURDIR)/.terraform

.PHONY: clean validate prepare help tests
