---
id: align
sidebar_position: 2
title: Align
---

## Vision
This section establishes the strategic foundation for the project

# Introduction and Intent
## Background and Intent
This Solution Document covers the following
- Validate MQIPT architecture for Guaranteed message delivery using IBM MQ
- Validate the function of MQIPT as a secure MQ proxy inn the DMZ
- High Availability and Disaster Recovery across multiples zones and regions using RDQM
- IBM MQ and MQIPT security constructs (LDAP authentication, MQIPT mTLS, SSL Peering, Channel security)

## Overview

This solution architecture demonstrates how you can deploy the Replicated Data Queue Manager in a Highly Available, Disaster Recovery enabled configuration across two regions that are interconnected/peered by a construct like the Transit Gateway (MZRs in IBM Cloud or Regions in AWS).

- MQIPT nodes are setup in a DMZ subnet that is able to accept traffic from the internet on port `1501` and `1502`. The IPT nodes proxy the traffic to an Application Load Balancer that in turn will direct the traffic to the active RDQM instance in one of the three active zones.

