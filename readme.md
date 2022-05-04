

# Introduction and Goals

## Background

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

## Overview

This solution architecture demonstrates how you can deploy the Replicated Data Queue Manager in a Highly Available, Disaster Recovery enabled configuration across two isolated regions (MZRs in IBM Cloud or Regions in AWS).

- MQIPT nodes are setup in the DMZ to accept traffic from the internet and proxy the traffic to Application Load Balancer that in turn will direct the traffic to the active RDQM instance in one of the three active zones.

## Building Block View

![test](./resources/rdqm-hadr-ibmcloud.png)
## Deployment
## [Deployment](Deployment.md)

## Security

## Cost

## Risks and Technical Debts

## Testing

# Architecture Decisions
