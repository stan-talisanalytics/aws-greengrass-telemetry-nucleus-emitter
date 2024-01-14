# Makefile for creating an AWS Greengrass Component

# Include environment variables from .env file
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Variables
COMPONENT_NAME=aws.greengrass.telemetry.NucleusEmitter
COMPONENT_VERSION=1.0.8
ARTIFACT_URL=https://github.com/stan-talisanalytics/aws-greengrass-telemetry-nucleus-emitter/releases/download/1.1.0/telemetry-nucleus-emitter-1.0.1-SNAPSHOT.jar
RECIPE_FILE=./recipe.json

# Set AWS configuration
aws_configure:
	aws configure set aws_access_key_id $(AWS_ACCESS_KEY_ID)
	aws configure set aws_secret_access_key $(AWS_SECRET_ACCESS_KEY)
	aws configure set default.region $(AWS_REGION)

# Create the recipe file
create_recipe:
	echo '{ \
  "RecipeFormatVersion": "2020-01-25", \
  "ComponentName": "$(COMPONENT_NAME)", \
  "ComponentVersion": "$(COMPONENT_VERSION)", \
  "ComponentType": "aws.greengrass.plugin", \
  "ComponentDescription": "Publishes real-time system telemetry locally and to AWS IoT Core.", \
  "ComponentPublisher": "AWS", \
  "ComponentConfiguration": { \
    "DefaultConfiguration": { \
      "telemetryPublishIntervalMs": "60000", \
      "pubSubPublish": "true", \
      "mqttTopic": "" \
    } \
  }, \
  "ComponentDependencies": { \
    "aws.greengrass.Nucleus": { \
      "VersionRequirement": ">=2.0.0 <2.13.0", \
      "DependencyType": "SOFT" \
    } \
  }, \
  "Manifests": [ \
    { \
      "Platform": { \
        "os": "*" \
      }, \
      "Lifecycle": {}, \
      "Artifacts": [ \
        { \
          "Uri": "$(ARTIFACT_URL)" \
        } \
      ] \
    } \
  ], \
  "Lifecycle": {} \
}' > $(RECIPE_FILE)

# Create Greengrass component
create_component: aws_configure create_recipe
	aws greengrassv2 create-component-version --inline-recipe file://$(RECIPE_FILE)

.PHONY: aws_configure create_recipe create_component
