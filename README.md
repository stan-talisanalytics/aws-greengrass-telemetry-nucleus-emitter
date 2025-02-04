# Greengrass Nucleus Telemetry Emitter
![Java CI](https://github.com/aws-greengrass/aws-greengrass-telemetry-nucleus-emitter/workflows/Java%20CI/badge.svg?branch=main)

This project requires Java 1.8

First, check which Java versions are installed on your Mac by running:

`/usr/libexec/java_home -V`

For zsh users, edit ~/.zshrc:

`export JAVA_HOME='/usr/libexec/java_home -v 1.8'`

The Greengrass Nucleus Telemetry Emitter component (aws.greengrass.telemetry.NucleusEmitter) gathers system health telemetry data and continually publishes it to an offline local topic and (optionally) an AWS IoT Core MQTT topic. This component enables the gathering of real-time system telemetry on your Greengrass core devices.

---
This plugin supports the following configuration options:
* `pubSubPublish`: toggle local pub/sub publishing. 
  * Default: `true`
* `mqttTopic`: the AWS IoT Core MQTT topic to publish to. 
  * Default: `""`
  * Optionally include `{core-device-name}` in topic, and it will be replaced with
    AWS IoT Thing Name from the running device. Example configure topic as `core-device/{core-device-name}/telemetry`
    and the published MQTT topic will be `core-device/my-example-iot-name/telemetry`
     
* `telemetryPublishIntervalMs`: the interval, in ms, at which to publish real-time telemetry. 
  * Default: `60000`
  * Minimum: `500`

By default, the plugin will begin publishing real-time telemetry once every 60 seconds to the local pub/sub topic `$local/greengrass/telemetry`.
Note that enabling publishing to AWS IoT Core may incur additional costs.

For more information, please see the [official Nucleus Telemetry Emitter documentation](https://docs.aws.amazon.com/greengrass/v2/developerguide/nucleus-emitter-component.html). 

---
## Security
See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

---
## License
*Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.*

*SPDX-License-Identifier: Apache-2.0*