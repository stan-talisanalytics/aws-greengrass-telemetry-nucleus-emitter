# Makefile for creating an AWS Greengrass Component

# Include environment variables from .env file
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Variables
COMPONENT_NAME=aws.greengrass.telemetry.NucleusEmitter
COMPONENT_VERSION=1.1.0

JAR_FILE=target/*-$(COMPONENT_VERSION)-SNAPSHOT.jar
BUCKET_NAME=parasanti-core-device-artifacts

S3_KEY=greengrass-components/telemetry-nucleus-emitter-$(COMPONENT_VERSION)-SNAPSHOT.jar
S3_URI=s3://$(BUCKET_NAME)/$(S3_KEY)
RECIPE_FILE=./recipe.json
ENCODED_RECIPE_FILE=./encoded_recipe.txt

# Upload JAR to S3
upload_jar_to_s3:
	aws s3 cp $(JAR_FILE) $(S3_URI)

# Create the recipe file
create_recipe: upload_jar_to_s3
	echo "{\"RecipeFormatVersion\":\"2020-01-25\",\"ComponentName\":\"$(COMPONENT_NAME)\",\"ComponentVersion\":\"$(COMPONENT_VERSION)\",\"ComponentType\":\"aws.greengrass.plugin\",\"ComponentDescription\":\"Publishes real-time system telemetry locally and to AWS IoT Core.\",\"ComponentPublisher\":\"AWS\",\"ComponentConfiguration\":{\"DefaultConfiguration\":{\"telemetryPublishIntervalMs\":\"60000\",\"pubSubPublish\":\"true\",\"mqttTopic\":\"\"}},\"ComponentDependencies\":{\"aws.greengrass.Nucleus\":{\"VersionRequirement\":\">=2.0.0 <2.13.0\",\"DependencyType\":\"SOFT\"}},\"Manifests\":[{\"Platform\":{\"os\":\"*\"},\"Lifecycle\":{},\"Artifacts\":[{\"Uri\":\"$(S3_URI)\"}]}],\"Lifecycle\":{}}" > $(RECIPE_FILE)

# Encode the recipe file in base64
encode_recipe: create_recipe
	cat $(RECIPE_FILE) | base64 > $(ENCODED_RECIPE_FILE)

# Create Greengrass component
create_component: encode_recipe
	aws greengrassv2 create-component-version --inline-recipe fileb://$(ENCODED_RECIPE_FILE)

.PHONY: upload_jar_to_s3 create_recipe encode_recipe create_component
