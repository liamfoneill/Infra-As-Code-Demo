## Working with Terraform Modules

A module is a container for multiple resources that are used together. You can use modules to create lightweight abstractions, so that you can describe your infrastructure in terms of its architecture, rather than directly in terms of physical objects.

The .tf files in your working directory when you run terraform plan or terraform apply together form the root module. That module may call other modules and connect them together by passing output values from one to input values of another.

To learn how to use modules, see the Modules configuration section. This section is about creating re-usable modules that other configurations can include using module blocks.

## When to write a module

In principle any combination of resources and other constructs can be factored out into a module, but over-using modules can make your overall Terraform configuration harder to understand and maintain, so we recommend moderation.

A good module should raise the level of abstraction by describing a new concept in your architecture that is constructed from resource types offered by providers.

For example, aws_instance and aws_elb are both resource types belonging to the AWS provider. You might use a module to represent the higher-level concept "HashiCorp Consul cluster running in AWS" which happens to be constructed from these and other AWS provider resources.

We do not recommend writing modules that are just thin wrappers around single other resource types. If you have trouble finding a name for your module that isn't the same as the main resource type inside it, that may be a sign that your module is not creating any new abstraction and so the module is adding unnecessary complexity. Just use the resource type directly in the calling module instead.

### Refactoring module resources

You can include refactoring blocks to record how resource names and module structure have changed from previous module versions. Terraform uses that information during planning to reinterpret existing objects as if they had been created at the corresponding new addresses, eliminating a separate workflow step to replace or migrate existing objects.

### Module Best Practices

- Encapsulation: Group infrastructure that is always deployed together.
Including more infrastructure in a module makes it easier for an end user to deploy that infrastructure but makes the module's purpose and requirements harder to understand.

- Privileges: Restrict modules to privilege boundaries.
If infrastructure in the module is the responsibility of more than one group, using that module could accidentally violate segregation of duties. Only group resources within privilege boundaries to increase infrastructure segregation and secure your infrastructure.

- Volatility: Separate long-lived infrastructure from short-lived.
For example, database infrastructure is relatively static while teams could deploy application servers multiple times a day. Managing database infrastructure in the same module as application servers exposes infrastructure that stores state to unnecessary churn and risk.

- Maximise outputs: Output as much information as possible from your module MVP even if you do not currently have a use for it. This will make your module more useful for end users who will often use multiple modules, using outputs from one module as inputs for the next. Remember to document the outputs in the module's README.

- Publish and share modules with your team. Most infrastructure is managed by a team of people, and modules are important way that teams can work together to create and maintain infrastructure. As mentioned earlier, you can publish modules either publicly or privately. Module users can reference published child modules in a root module, or deploy no-code ready modules through the Terraform Cloud UI.


### Good Links

- Tutorial: Reuse Configuration with Modules (Hashicorp): https://developer.hashicorp.com/terraform/tutorials/modules?utm_source=WEBSITE&utm_medium=WEB_IO&utm_offer=ARTICLE_PAGE&utm_content=DOCS