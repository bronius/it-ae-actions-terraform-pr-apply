
Before seriously committing:
* Add back s3 handling or deprecate it
* Check other use cases (failing apply, PR commenting..)

# it-ae-actions-terraform-pr-apply

A GitHub Composite action for applying terraform state changes when a pull request is merged.

This action requires a pull request to be associated with the run. If a pull request id is not passed as an input, the action will attempt to find the pull request ID with a matching merge commit hash. If not pull request id is found, the action will fail.

The `terraform apply` output will be posted to the pull request as a comment, trimmed to 65535 characters. The full output log will also be uploaded to s3 and a link to the log will be posted to the pull request as a comment.

## Usage

Set up AWS access credentials using an action such as [aws-actions/configure-aws-credentials@v2](https://github.com/aws-actions/configure-aws-credentials), then use the action in your workflow:

```yaml
steps:
  - name: Terraform Apply Composite Action
    uses: tamu-edu/it-ae-actions-terraform-pr-apply@main
    with:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      terraform-workspace: ${{ env.environment }}
      working-directory: terraform
      terraform-version: ~1.4.0
```

## Limitations

Currently, this action only supports terraform whose state is stored in s3. The IAM role used to run this action must have access to the s3 bucket where the terraform state is stored and be able to create new objects at the backend's key prefix, or to the provided s3 bucket and key override inputs.

## Inputs

<!-- AUTO-DOC-INPUT:START - Do not remove or modify this section -->

|          INPUT           |  TYPE  | REQUIRED |   DEFAULT   |                                                      DESCRIPTION                                                      |
|--------------------------|--------|----------|-------------|-----------------------------------------------------------------------------------------------------------------------|
|       GITHUB_TOKEN       | string |   true   |             |                                   GitHub token for access to the <br>pull request                                     |
|       auto-approve       | string |  false   |  `"true"`   |                                             Auto approve terraform apply                                              |
|          debug           | string |  false   |  `"false"`  |                                   Debug workflow with tmate if an <br>error occurs                                    |
|          pr-id           | string |  false   |             |     Associate the run with a specific <br>pull request id. Defaults to finding <br>the ID from the merge commit.      |
|        s3-bucket         | string |  false   |             |              Override s3 bucket to upload output <br>to. Defaults to the same as <br>the state backend.               |
|          s3-key          | string |  false   |             |         Override s3 object key to upload <br>output to. Defaults to a subdirectory <br>of the statefile key.          |
|  terraform-apply-flags   | string |  false   |             |          (DEPRECATED) Ignored if not '-var-file=' related. <br>Use 'terraform-var-file' input for var file.           |
| terraform-backend-config | string |  false   |             |                                 Backend tfstate config to pass to <br>terraform init                                  |
|   terraform-init-flags   | string |  false   |             | (DEPRECATED) Ignored if not '-backend-config=' related. <br>Use 'terraform-backend-config' input for backend config.  |
|    terraform-var-file    | string |  false   |             |                                Terraform variable file to pass to <br>terraform apply                                 |
|    terraform-version     | string |  false   | `"latest"`  |                                            Version of terraform to install                                            |
|   terraform-workspace    | string |  false   | `"default"` |                                Terraform workspace to select. Must already <br>exist                                  |
|    working-directory     | string |  false   |             |                                        Working directory for the `run` actions                                        |

<!-- AUTO-DOC-INPUT:END -->

## Outputs

<!-- AUTO-DOC-OUTPUT:START - Do not remove or modify this section -->

|    OUTPUT    |  TYPE  |               DESCRIPTION                |
|--------------|--------|------------------------------------------|
| apply_output | string |        The terraform apply output        |
|   plan_url   | string |      URL of the plan file artifact.      |
|   s3_path    | string | The S3 URL of the uploaded <br>log file  |

<!-- AUTO-DOC-OUTPUT:END -->
