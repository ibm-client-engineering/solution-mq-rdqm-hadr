<!-- vscode-markdown-toc -->
* 1. [Background](#Background)
* 2. [Goals](#Goals)
* 3. [Overview](#Overview)
* 4. [Building Block View](#BuildingBlockView)
* 5. [Deployment](#Deployment)
* 6. [Security](#Security)
* 7. [Cost](#Cost)
* 8. [Risks and Technical Debts](#RisksandTechnicalDebts)
* 9. [Testing](#Testing)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

# Introduction and Goals

##  1. <a name='Background'></a>Background


##  2. <a name='Goals'></a>Goals
The goal of this project is to demonstrate the following proposed topologies in a hybrid multi-cloud scenario:
- Setting up architectures, configurations and standards for distributed app rotation
- Guaranteed message delivery
- Overall guidance on security exits
- Delivery over other mechanisms, not just MQ server
- Multiple availability zones across multiple clouds
- 
Doing this would be great, because we will:
- Validate MQIPT use cases
- Enhance productivity and user experience by how easy it is to define and deploy
- Develop pattern for modernization efforts

## Goals


# Solution Strategy

##  3. <a name='Overview'></a>Overview

This solution architecture demonstrates how you can deploy the Replicated Data Queue Manager in a Highly Available, Disaster Recovery enabled configuration across two isolated regions (MZRs in IBM Cloud or Regions in AWS).

- MQIPT nodes are setup in the DMZ to accept traffic from the internet and proxy the traffic to Application Load Balancer that in turn will direct the traffic to the active RDQM instance in one of the three active zones.

##  4. <a name='BuildingBlockView'></a>Building Block View

![test](./resources/rdqm-hadr-ibmcloud.png)
##  5. <a name='Deployment'></a>Deployment

##  6. <a name='Security'></a>Security

##  7. <a name='Cost'></a>Cost

##  8. <a name='RisksandTechnicalDebts'></a>Risks and Technical Debts

##  9. <a name='Testing'></a>Testing

# Architecture Decisions
