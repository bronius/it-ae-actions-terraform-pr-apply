#!/bin/bash

copy_logs () {

  # Setup pull key path
  key="$key_prefix/$key_name"

  backend_config="${working_directory}/.terraform/terraform.tfstate"
  backend_type=$(jq -r '.backend.type' $backend_config)

  # Output locally if not in github actions
  if [[ -z $GITHUB_OUTPUT ]]; then
    GITHUB_OUTPUT="./github_actions.out"
    true > $GITHUB_OUTPUT
  fi

  # Setting output for github actions
  echo "backend_type=$backend_type" >> $GITHUB_OUTPUT

  case $backend_type in
    s3)
      [[ -z $bucket ]] && bucket=$(jq -r '.backend.config.bucket' $backend_config)
      s3_url="s3://${bucket}/${key}"

      output="Copying apply log to AWS S3 at $s3_url"
      echo "$output"

      # Setting outputs for github actions
      echo "bucket=$bucket" >> $GITHUB_OUTPUT
      echo "key=$key" >> $GITHUB_OUTPUT
      echo "s3_url=$s3_url" >> $GITHUB_OUTPUT
      echo "output=$output" >> $GITHUB_OUTPUT

      [[ ! $dryrun ]] && aws s3 cp "${source_file}" "${s3_url}"
      return
      ;;

    azurerm)
      [[ -z $resource_group_name ]]  && resource_group_name=$(jq -r '.backend.config.bucket' $backend_config)
      [[ -z $storage_account_name ]] && storage_account_name=$(jq -r '.backend.config.bucket' $backend_config)
      [[ -z $container ]]            && container=$(jq -r '.backend.config.bucket' $backend_config)

      output="Copying apply log to Azure at $storage_account_name / $container at $key"
      echo $output

      # Setting outputs for github actions
      echo "resource_group_name=$resource_group_name" >> $GITHUB_OUTPUT
      echo "storage_account_name=$storage_account_name" >> $GITHUB_OUTPUT
      echo "key=$key" >> $GITHUB_OUTPUT
      echo "container=$container" >> $GITHUB_OUTPUT
      echo "output=$output" >> $GITHUB_OUTPUT

      [[ ! $dryrun ]] && az storage azcopy blob upload --container "$container" --account-name "$storage_account_name" --source "${source_file}" --destination "$key"
      return
      ;;

    gcs)
      [[ -z $bucket ]] && bucket=$(jq -r '.backend.config.bucket' $backend_config)
      gs_url="gs://${bucket}/${key}"

      output="Copying apply log to GCP at $gs_url"
      echo $output

      # Setting outputs for github actions
      echo "bucket=$bucket" >> $GITHUB_OUTPUT
      echo "key=$key" >> $GITHUB_OUTPUT
      echo "gs_url=$gs_url" >> $GITHUB_OUTPUT
      echo "output=$output" >> $GITHUB_OUTPUT

      [[ ! $dryrun ]] && gsutil cp "${source_file}" "${gs_url}"
      return
      ;;

    
    *)
      echo "The backend type could not be determined or isn't supported ($backend_type)"
  esac
}
