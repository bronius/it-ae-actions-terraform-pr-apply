#!/bin/bash
source './assert.sh'

dryrun=true
source_file="apply_logs.txt"
# [[ -n "${{ inputs.key-prefix }}" ]] && key_prefix="${{ inputs.key-prefix }}" || key_prefix="apply_logs"
key_prefix="apply_logs"
bucket="my-terraform-state-bucket"
#  [[ -n "${{ inputs.key-name }}" ]] && key_name="${{ inputs.key-name }}" || key_name="${{ github.repository }}/pr-${{ steps.pr_id.outputs.number }}/$(date -u +'%Y-%m-%d/apply-%Y-%m-%dT%H:%M:%SZ.log')"
key_name="tamu-edu/test-repo/pr-21/$(date -u +'%Y-%m-%d/apply-%Y-%m-%dT%H:%M:%SZ.log')"

test_output () {
  [ "$?" == 0 ] && log_success "$test_name" || echo $(log_failure "$test_name" && echo "$output != $expected")
}

source ../copy_logs.sh

# AWS S3

working_directory="test-s3"


test_name="S3 backend with all values from terraform"
output=$(copy_logs)
assert_eq "$output" "Copying apply log to AWS S3 at s3://$bucket/$key_prefix/$key_name"
test_output

test_name="S3 backend with override bucket"
override="override-bucket-name"
output=$(bucket="$override" copy_logs)
assert_eq "$output" "Copying apply log to AWS S3 at s3://$override/$key_prefix/$key_name"
test_output

test_name="S3 backend with override key_prefix"
override="override-key-prefix"
output=$(key_prefix="$override" copy_logs)
expected="Copying apply log to AWS S3 at s3://$bucket/$override/$key_name"
assert_eq "$output" "$expected"
test_output

test_name="S3 backend with override key_name"
override="custom-key-name"
output=$(key_name="$override" copy_logs)
expected="Copying apply log to AWS S3 at s3://$bucket/$key_prefix/$override"
assert_eq "$output" "$expected"
test_output


# Azure RM
working_directory="test-azurerm"
resource_group_name="my-resource-group"
storage_account_name="my-storage-account"
container="my-storage-container"

test_name="Azure backend with all values from terraform"
output=$(copy_logs)
assert_eq "$output" "Copying apply log to Azure at $storage_account_name / $container at $key_prefix/$key_name"
test_output

test_name="Azure backend with override resource group"
override="override-resource-group"
output=$(resource_group_name="$override" copy_logs)
assert_eq "$output" "Copying apply log to Azure at $storage_account_name / $container at $key_prefix/$key_name"
test_output

test_name="Azure backend with override storage account"
override="override-storage-account"
output=$(storage_account_name="$override" copy_logs)
assert_eq "$output" "Copying apply log to Azure at $override / $container at $key_prefix/$key_name"
test_output

test_name="Azure backend with override container"
override="override-container"
output=$(container="$override" copy_logs)
assert_eq "$output" "Copying apply log to Azure at $storage_account_name / $override at $key_prefix/$key_name"
test_output

test_name="Azure backend with override key_prefix"
override="override-key-prefix"
output=$(key_prefix="$override" copy_logs)
assert_eq "$output" "Copying apply log to Azure at $storage_account_name / $container at $override/$key_name"
test_output

test_name="Azure backend with override key_name"
override="override-key-name"
output=$(key_name="$override" copy_logs)
assert_eq "$output" "Copying apply log to Azure at $storage_account_name / $container at $key_prefix/$override"
test_output
