

# Introduction and Goals

## Background

## Goals

# Solution Strategy

## Overview

This solution architecture demonstrates how you can deploy the Replicated Data Queue Manager in a Highly Available, Disaster Recovery enabled configuration across two isolated regions (MZRs in IBM Cloud or Regions in AWS).

- MQIPT nodes are setup in the DMZ to accept traffic from the internet and proxy the traffic to Application Load Balancer that in turn will direct the traffic to the active RDQM instance in one of the three active zones.

## Building Block View

![test](./resources/rdqm-hadr-ibmcloud.png)
## Deployment

## Security

## Cost

## Risks and Technical Debts

## Testing

# Architecture Decisions
