---
id: stage
sidebar_position: 3
title: Stage
---

## Security
<b>MQIPT Security with TLS</b>
MQIPT accepts a TLS from a queue manager or a client, the certificate is validated. The MQIPT also terminates the connection this allows for dynamic configuration of backend servers.

- Certificates can be blocked or accepted based on the Distinguished Name.
- Certificate revocation checking is preformed.
- A certificate exit can be written to perform additional checks.

<b>Advanced Message Security ( AMS )</b> expands IBM MQ security services to provide data signing and encryption at the message level. The expanded services guarantees that message data has not been modified between when it is originally placed on a queue and when it is retrieved. In addition, AMS verifies that a sender of message data is authorized to place signed messages on a target queue.