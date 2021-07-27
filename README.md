# heat_template

<H3>Overview</H3>
This repository contains examples of how to use Heat templates in OpenStack. With Heat you can easily deploy a group of resources with one operation, and later remove all the related resources. In Heat terminology such group of resources is called a "stack". An example of a multi-instance stack could be deployment of a web-server and database server instance along with the required network connections.

It is up to the creator of Heat templates to decide what resources are considered as baseline already existing in the cloud, and what resources will be created by the Heat template.
# openstack-heat
Automation examples for Openstack using the HEAT templating language

## What is HEAT?
HEAT is Openstack's template-driven orchestration engine. It allows
users to define servers, networks, storage etc as "YAML"
(https://en.wikipedia.org/wiki/YAML)  templates which
can then be deployed as "Stacks" to create complex systems which are
scalable, repeatable and automatable.
See: https://wiki.openstack.org/wiki/Heat for more info on what HEAT is.



<H3>References</H3>
- <A HREF='http://docs.openstack.org/developer/heat/template_guide/' target="_blank">Heat template guide</A>
- <A HREF='http://docs.openstack.org/cli-reference/heat.html' target='_blank'>Heat CLI reference</A>
- <A HREF='http://docs.ansible.com/ansible/os_stack_module.html' target='_blank'>Ansible module for using Heat</A>
