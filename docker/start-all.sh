#!/usr/bin/env bash

# get the absolute path of the executable
SELF_PATH=$(cd -P -- "$(dirname -- "$0")" && pwd -P) && SELF_PATH="$SELF_PATH"/$(basename -- "$0")

echo "Stopping all"
docker ps | \
grep "auth-server\|config-server\|config-test\|eureka-server\|auth-mongodb\|gateway\|kibana\|elasticsearch\|fluentd\|monitoring\|account-service\|account-mongodb\|rabbitmq\|notification-service\|notification-mongodb\|store-service\|store-mongodb\|appointment-service\|appointment-mongodb" | \
awk '{print $1}' | xargs docker stop

echo -n "Build new images? y/n"
read build_images
if [ "$build_images" == "y" ]; then
	echo "Generating ngnix image..."
	cd ./../nginx/
	sh ./build_image.sh

	echo "Generating mongodb image..."
	cd ./../mongodb/
	sh ./build_image.sh

	echo "Generating fluentd image..."
	cd ./../fluentd/
	sh ./build_image.sh

    echo "Generating auth-server image..."
	cd ./../auth-server/
	sh ./build_image.sh
	
	echo "Generating config-server image..."
	cd ./../config-server/
	sh ./build_image.sh
	
	echo "Generating config-test image..."
	cd ./../config-test/
	sh ./build_image.sh
	
	echo "Generating eureka-server image..."
	cd ./../eureka-server/
	sh ./build_image.sh

	echo "Generating gateway image..."
	cd ./../gateway/
	sh ./build_image.sh

	echo "Generating elasticsearch image..."
	cd ./../elasticsearch/
	sh ./build_image.sh
	
	echo "Generating monitoring image..."
	cd ./../monitoring/
	sh ./build_image.sh

	echo "Generating kibana image..."
	cd ./../kibana/
	sh ./build_image.sh
	
	echo "Generating account image..."
	cd ./../account-service/
	sh ./build_image.sh
	
	echo "Generating notification image..."
	cd ./../notification-service/
	sh ./build_image.sh

	echo "Generating store image..."
	cd ./../store-service/
	sh ./build_image.sh

	echo "Generating appointment-service image..."
	cd ./../appointment-service/
	sh ./build_image.sh

	
fi

#echo "Starting your local dockerized full stack with mounted volumes"
cd ./../docker/
docker-compose -f docker-compose-files/full-stack.yml up -d
