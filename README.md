## Accounts

Within accounts, you can define the multiple environments where you want to deploy your resources using Terragrunt. For example, two different regions where defined within the test account.

## Modules

Terraform Modules

### App

Contains the ASG, ALB and related resources for the application to run and route traffic.

### Organizations

Declares the organization service control policies.

### Vpc

Contains the networking resources and configuration.
