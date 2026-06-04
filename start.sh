#!/bin/bash
cd app
mvn clean package -DskipTests
java -jar target/app-0.0.1-SNAPSHOT.jar
